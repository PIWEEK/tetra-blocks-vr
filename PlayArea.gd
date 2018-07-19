extends Spatial

var figure = load("res://Figure.tscn")
var main
var player
var rightHand
var leftHand
var testCount = 0;
var timer
const INITIAL_POSITION = {
	"row": 17,
	"column": 3
}

var figureNode = figure.instance()
var matrix = []
var areas = []
var dropCandidateBlocks = []
var dropCandidateMatrix
var dropInProgress = false
var currentDropCandidate
var oldDropCandidate
var inMainArea = false
var nextMoveReady = false

func _ready():	
	for row in range(0, 20):
		matrix.append([])
		for column in range(0, 10):
			matrix[row].append(null)
			createArea(row, column)
	
	main = get_node("/root/Main")
	player = main.get_node("PlayerOrigin")
	rightHand = player.get_node("RightHand")
	
	player.connect("throw", self, "drop")
	
	timer = get_node("Timer")
	
	timer.connect("timeout", self, "spawn")
	get_node("Timer2").connect("timeout", self, "prepareMove")
	
	get_node("MainArea").connect("area_entered", self, "enterMainArea")
	get_node("MainArea").connect("area_exited", self, "leaveMainArea")
	
	main.addMatrix(matrix) 

func addFigure(type, initialRow, initialColumn):
	disableSpawn()
	main.addFigure(get_name(), type)
	var figureData = figureNode.create(type)
	
	figureData.matrix.invert()
	
	for row in range(figureData.matrix.size()):
		for column in range(figureData.matrix[row].size()):
			if figureData.matrix[row][column]:
				var currentRow = row + initialRow
				var currentColumn = column + initialColumn
				var currentFigure = figureData.cubes.pop_front()
				
				matrix[currentRow][currentColumn] = {
					"current": true,
					"cube": currentFigure,
					"type": type
				}

				currentFigure.scale_object_local(Vector3(0.1, 0.1, 0.1))
				
				add_child(currentFigure)
				moveFigure(currentFigure, currentRow, currentColumn)
	
func moveFigure(node, row, column):
	node.translation.x = 0.2 * column
	node.translation.y = 0.2 * row
		
func canMove():
	var move = true
	
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			
			if node && node.current:
				var newRow = row - 1
				
				if newRow < 0 || (matrix[newRow][column] != null && !matrix[newRow][column].current):
					move = false
					
	return move
			
func disableCurrent():
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			if node:
				node.current = false

func prepareMove():
	nextMoveReady = true

func move():
	if !canMove():
		disableCurrent()
		removeFilledLines()
		enableSpawn()
		return null
	
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			if node && node.current:
				var newRow = row - 1
				if newRow >= 0:
					matrix[newRow][column] = node
					matrix[row][column] = null;
					moveFigure(node.cube, newRow, column)

func createArea(row, column):
	var area = Area.new()
	area.translation.y = 0.2 * row
	area.translation.x = 0.2 * column
	
	var collision = CollisionShape.new()
	collision.scale_object_local(Vector3(0.1, 0.1, 0.1))
	collision.shape = BoxShape.new()
	area.add_child(collision)

	area.connect("area_entered", self, "enterArea", [row, column])
	
	add_child(area)
	areas.append({
		"row": row,
		"column": column,
		"node": area
	})
	
func exitArea():
	deleteDropCandidate()
	
func enterArea(body, row, column):
	if body.get_parent().get_name() == 'RightHand' && body.get_parent().get_node('Figure').get_child_count() > 0:
		# print('enter, ', row, ', ', column)
		currentDropCandidate = {
			"type": main.getDrag().type,
			"row": row,
			"column": column	
		}
		
func removeCurrent():
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			if node && node.current:
				node.cube.get_parent().remove_child(node.cube)
				matrix[row][column] = null

func removeFilledLines():
	var rowsToDelete = []
	
	for row in range(matrix.size()):
		var rowToDelete = row
		
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			
			if !node:
				rowToDelete = null
		
		if rowToDelete != null:
			rowsToDelete.append(rowToDelete)
	
	for rowToDelete in rowsToDelete:
		for column in range(matrix[rowToDelete].size()):
			var node = matrix[rowToDelete][column]
			
			if node:
				node.cube.get_parent().remove_child(node.cube)
				matrix[rowToDelete][column] = null
				
	if !rowsToDelete.size():
		return null
	
	for row in range(matrix.size()):
		if row > rowsToDelete[rowsToDelete.size() - 1]:
			for column in range(matrix[row].size()):
				var node = matrix[row][column]
				
				if node:
					var newRow = row - rowsToDelete.size() 
					
					matrix[newRow][column] = node
					matrix[row][column] = null;
					
					moveFigure(node.cube, newRow, column)
			
#func rotateMatrix(matrix):
#	var rowLength = sqrt(matrix.size())
#	var newMatrix = []
#
#	for row in range(matrix.size()):
#		newMatrix.append([])
#
#		for column in range(matrix[row].size()):
#			matrix[row].append(null)	
#
#	for i in range(matrix.size()):
#	    # convert to x/y
#		var x = fmod(float(i), rowLength)
#		var y = floor(i / rowLength)
#
#		# find new x/y
#		var newX = rowLength - y - 1
#		var newY = x
#
#		# convert back to index
#		var newPosition = newY * rowLength + newX;
#		newMatrix[newPosition] = matrix[i];
#
#	return newMatrix
	
func rotateMatrix(matrix, dir):
	var newMatrix = []

	for row in range(matrix.size()):
		newMatrix.append([])

		for column in range(matrix[row].size()):
			newMatrix[row].append(null)
	
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var rowColumn = matrix[row][column]
			var columnRow = matrix[column][row] 

			newMatrix[row][column] = columnRow
			newMatrix[column][row] = rowColumn

	if dir:
		for row in range(newMatrix.size()):	
			newMatrix[row].invert()
	else:
		newMatrix.invert()
		
	return newMatrix

func calculateMatrixSubstract(matrix):
	var currentRow = 0
	var currentColumn = 0
	var precisionRow = matrix.size()
	var precisionColumn = matrix.size()
	var center = ceil(float(matrix.size()) / float(2)) - 1
	print(matrix.size())
	print(float(matrix.size()) / float(2))
	print(center)
	
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			
			if node && center - row < precisionRow:
				precisionRow = center - row
				currentRow = row

	for column in range(matrix[currentRow].size()):
		var node = matrix[currentRow][column]
		print('column')
		print('center, ', center)
		print('column, ', column)
		print('precisionColumn, ', precisionColumn)
		var precision = center - column
		if precision < 0:
			precision = -precision
		
		if node && precision < precisionColumn:
			precisionColumn = precision
			currentColumn = column
			print('write')
	# 
	#
	return {
		"x": currentColumn,	
		"y": currentRow
	}

func dropCandidate(type, initialRow, initialColumn):
	removeCurrent()
	disableSpawn()
	dropInProgress = true
	
	if dropCandidateBlocks.size():
		var count = 0
		
		var centerSubstract = calculateMatrixSubstract(dropCandidateMatrix)
		
		for row in range(dropCandidateMatrix.size()):
			for column in range(dropCandidateMatrix[row].size()):
				if dropCandidateMatrix[row][column]:
					var currentRow = row + initialRow - centerSubstract.y
					var currentColumn = column + initialColumn - centerSubstract.x
					var currentFigure = dropCandidateBlocks[count]
					
					count = count + 1
					
					for currentBlockCandidate in dropCandidateBlocks:
						if currentBlockCandidate.cube == currentFigure.cube:
							currentBlockCandidate.row = currentRow
							currentBlockCandidate.column = currentColumn

					moveFigure(currentFigure.cube, currentRow, currentColumn)
	else:
		var figureData = figureNode.create(type) 
		figureData.matrix.invert()
		
		var rotateTimes = 0
		if rightHand.rotation_degrees.z > 0 && rightHand.rotation_degrees.z <= 45:
			rotateTimes = 0
		elif rightHand.rotation_degrees.z > 45 && rightHand.rotation_degrees.z <= 135:
			rotateTimes = 1
		elif rightHand.rotation_degrees.z > 135 && rightHand.rotation_degrees.z <= 180:
			rotateTimes = 2
		elif rightHand.rotation_degrees.z < 0 && rightHand.rotation_degrees.z >= -45:
			rotateTimes = 0
		elif rightHand.rotation_degrees.z < -45 && rightHand.rotation_degrees.z >= -135:
			rotateTimes = 1
		elif rightHand.rotation_degrees.z < -135 && rightHand.rotation_degrees.z >= -180:
			rotateTimes = 2
		
		var rotatedMatrix = figureData.matrix
		var dir = false
		
		if rightHand.rotation_degrees.z > 0:
			dir = true
		
		for i in range(rotateTimes):
			rotatedMatrix = rotateMatrix(rotatedMatrix, dir)
			
		print('----------------------------')
		print(rotatedMatrix)
		var centerSubstract = calculateMatrixSubstract(rotatedMatrix)
		print(centerSubstract)
			
		dropCandidateMatrix = rotatedMatrix
		
		for row in range(dropCandidateMatrix.size()):
			for column in range(dropCandidateMatrix[row].size()):
				if dropCandidateMatrix[row][column]:
					var currentRow = (row + initialRow) - centerSubstract.y
					var currentColumn = (column + initialColumn) - centerSubstract.x
					var currentFigure = figureData.cubes.pop_front()
	
					currentFigure.scale_object_local(Vector3(0.1, 0.1, 0.1))				
					
					add_child(currentFigure)
					moveFigure(currentFigure, currentRow, currentColumn)
					
					dropCandidateBlocks.append({
						"matrix": figureData.matrix,
						"row": currentRow,
						"column": currentColumn,
						"cube": currentFigure,
						"type": type					
					})
		
func resetDrop():
	dropCandidateBlocks = []
	dropCandidateMatrix = null
	dropInProgress = false
	currentDropCandidate = null
	oldDropCandidate = null	
				
func confirmDropCandidate():
	for currentBlockCandidate in dropCandidateBlocks:
		matrix[currentBlockCandidate.row][currentBlockCandidate.column] = {
			"current": true,
			"cube": currentBlockCandidate.cube,
			"type": currentBlockCandidate.type
		}
		
		# print(currentBlockCandidate.row, ' | ', currentBlockCandidate.column)
	if dropCandidateBlocks.size() > 0:
		main.addFigure(get_name(), dropCandidateBlocks[0].type)
	
	resetDrop()
				
func deleteDropCandidate():
	for it in dropCandidateBlocks:
		remove_child(it.cube);
		
	resetDrop()
	enableSpawn()
	
func enterMainArea(area):
	inMainArea = true
	main.setActiveMatrix(matrix)
	main.setActivePlayArea(self)
	
func leaveMainArea(area):
	if dropInProgress:
		deleteDropCandidate()
	inMainArea = false
	
func drop():
	confirmDropCandidate()
	
func randomFigure():
	var figures = ['s', 'j', 'i', 't', 'l', 'o', 'z']
	
	return figures[floor(rand_range(0, figures.size() - 1))]

func disableSpawn():
	timer.stop()
	
func enableSpawn():
	timer.start()
	
func spawn():
	addFigure(randomFigure(), INITIAL_POSITION.row, INITIAL_POSITION.column)
	testCount = testCount + 1
		
func _process(delta):
	# print(str(Engine.get_frames_per_second()))
	if nextMoveReady:
		move()
		nextMoveReady = false

	if inMainArea && currentDropCandidate && (!oldDropCandidate || (currentDropCandidate.row != oldDropCandidate.row || currentDropCandidate.column != oldDropCandidate.column)):
		dropCandidate(currentDropCandidate.type, currentDropCandidate.row, currentDropCandidate.column)

		oldDropCandidate = {
			"row": currentDropCandidate.row,
			"column": currentDropCandidate.column
		}