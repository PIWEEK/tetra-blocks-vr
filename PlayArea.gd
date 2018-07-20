extends Spatial

var figure = load("res://Figure.tscn")
var main
var player
var rightHand
var leftHand
var testCount = 0;
var timer
const ROWS = 20
const COLUMNS = 10
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
var nextMoveReady = false
var mainArea 
var rotateOnInitDrop = false
var dropCandidateOriginal

func _ready():	
	for row in range(0, ROWS):
		matrix.append([])
		for column in range(0, COLUMNS):
			matrix[row].append(null)
			createArea(row, column)
	
	main = get_node("/root/Main")
	player = main.get_node("PlayerOrigin")
	rightHand = player.get_node("RightHand")
	
	player.connect("throw", self, "drop")
	
	timer = get_node("Timer")
	
	timer.connect("timeout", self, "spawn")
	get_node("Timer2").connect("timeout", self, "prepareMove")
	mainArea = get_node("MainArea")
	mainArea.connect("area_entered", self, "enterMainArea")
	mainArea.connect("area_exited", self, "leaveMainArea")
	
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
#	if get_name() == 'PlayArea':
#		var area = Area.new()
#		area.translation.y = 0.2 * row
#		area.translation.x = 0.2 * column
#
#		var collision = CollisionShape.new()
#		collision.scale_object_local(Vector3(0.1, 0.1, 0.1))
#		collision.shape = BoxShape.new()
#		area.add_child(collision)
#
#		# area.connect("area_entered", self, "enterArea", [row, column])
#
#		add_child(area)
	areas.append({
		"row": row,
		"column": column,
		# "node": area
	})
	
func exitArea():
	deleteDropCandidate()
		
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
#	print(matrix.size())
#	print(float(matrix.size()) / float(2))
#	print(center)
	
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			
			if node && center - row < precisionRow:
				precisionRow = center - row
				currentRow = row

	for column in range(matrix[currentRow].size()):
		var node = matrix[currentRow][column]
#		print('column')
#		print('center, ', center)
#		print('column, ', column)
#		print('precisionColumn, ', precisionColumn)
		var precision = center - column
		if precision < 0:
			precision = -precision
		
		if node && precision < precisionColumn:
			precisionColumn = precision
			currentColumn = column
#			print('write')
	# 
	#
	return {
		"x": currentColumn,	
		"y": currentRow
	}
	
func calculateOutOfLimits(matrix, initialColumn, centerSubstract):
	var outOfLimitX = 0
	
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			if matrix[row][column]:
				var currentColumn = column + initialColumn - centerSubstract.x
				
				if currentColumn >= COLUMNS && currentColumn > outOfLimitX:
					outOfLimitX = currentColumn
				elif currentColumn < 0 && currentColumn < outOfLimitX:
					outOfLimitX = currentColumn
	
	if outOfLimitX >= COLUMNS:
		outOfLimitX = COLUMNS - outOfLimitX - 1
	else:
		outOfLimitX = -outOfLimitX

	return outOfLimitX
	
func getRotates():
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
	
	return rotateTimes
	
func dropCandidate(type, initialRow, initialColumn):
	removeCurrent()
	disableSpawn()
	dropInProgress = true
	
	if dropCandidateBlocks.size():
		var count = 0
		
		var rotateTimes = getRotates()

		var rotatedMatrix = dropCandidateOriginal
		var dir = false
		
		if rightHand.rotation_degrees.z > 0:
			dir = true
		
		for i in range(rotateTimes):
			rotatedMatrix = rotateMatrix(rotatedMatrix, dir)		
		
		var centerSubstract = calculateMatrixSubstract(rotatedMatrix)
		
		var outOfLimitX = calculateOutOfLimits(rotatedMatrix, initialColumn, centerSubstract)
		
		for row in range(rotatedMatrix.size()):
			for column in range(rotatedMatrix[row].size()):
				if rotatedMatrix[row][column]:
					var currentRow = row + initialRow - centerSubstract.y
					var currentColumn = column + initialColumn - centerSubstract.x + outOfLimitX
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
		
		var rotateTimes = getRotates()
		
		if rotateTimes:
			rotateOnInitDrop = rotateTimes
		else:
			rotateOnInitDrop = 0
		
		var rotatedMatrix = figureData.matrix
		var dir = false
		dropCandidateOriginal = figureData.matrix
		
		if rightHand.rotation_degrees.z > 0:
			dir = true
		
		for i in range(rotateTimes):
			rotatedMatrix = rotateMatrix(rotatedMatrix, dir)

		var centerSubstract = calculateMatrixSubstract(rotatedMatrix)
		
		dropCandidateMatrix = rotatedMatrix
		
		var outOfLimitX = calculateOutOfLimits(dropCandidateMatrix, initialColumn, centerSubstract)
		
		for row in range(dropCandidateMatrix.size()):
			for column in range(dropCandidateMatrix[row].size()):
				if dropCandidateMatrix[row][column]:
					var currentRow = (row + initialRow) - centerSubstract.y
					var currentColumn = (column + initialColumn) - centerSubstract.x + outOfLimitX
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
	dropCandidateOriginal = null
				
func confirmDropCandidate():
	for currentBlockCandidate in dropCandidateBlocks:
		if currentBlockCandidate.row < ROWS && currentBlockCandidate.column < COLUMNS && currentBlockCandidate.row >= 0 && currentBlockCandidate.column >= 0:
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
	if !main.getDrag() || !main.getActivePlayArea():
		print('...............................')
		print('enter, ', self.get_name())
		print('drag, ', main.getDrag())
		print('getActivePlayArea, ', main.getActivePlayArea())
		main.setActiveMatrix(matrix)
		main.setActivePlayArea(self)
	
func leaveMainArea(area):
	if dropInProgress:
		deleteDropCandidate()
		
	main.setActivePlayArea(null)
	
func isMainArea():
	return main.getActivePlayArea() == self
	
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

func enterArea(row, column):
	if main.getDrag():
		currentDropCandidate = {
			"type": main.getDrag().type,
			"row": row,
			"column": column	
		}

func _process(delta):
	# print(str(Engine.get_frames_per_second()))
	
	if nextMoveReady:
		move()
		nextMoveReady = false
	
	if isMainArea() && currentDropCandidate && (!oldDropCandidate || (currentDropCandidate.row != oldDropCandidate.row || currentDropCandidate.column != oldDropCandidate.column)):
		dropCandidate(currentDropCandidate.type, currentDropCandidate.row, currentDropCandidate.column)

		oldDropCandidate = {
			"row": currentDropCandidate.row,
			"column": currentDropCandidate.column
		}
		
	if isMainArea() && main.getDrag():
		var column
		var columnHand
		var rowHand
		
		if self.rotation_degrees.y == 0:
			column = self.global_transform.origin.x
			columnHand = rightHand.global_transform.origin.x
			rowHand = rightHand.global_transform.origin.y
		elif self.get_name() == 'PlayArea2': # opposite main play area
			column = -self.global_transform.origin.x
			columnHand = -rightHand.global_transform.origin.x
			rowHand = rightHand.global_transform.origin.y			
		elif self.get_name() == 'PlayArea3': # opposite main play area
			column = -self.global_transform.origin.z
			columnHand = -rightHand.global_transform.origin.z
			rowHand = rightHand.global_transform.origin.y
		else:
			column = self.global_transform.origin.z
			columnHand = rightHand.global_transform.origin.z
			rowHand = rightHand.global_transform.origin.y
			
		# print(columnHand, ' | ', self.rotation_degrees.y)		
			
		for area in areas:
			# print("area ", area.node.global_transform)
			var x = column + area.column * 0.1
			var xx = x + 0.1
			# print(x, ' | ', xx)
			
			var y = self.global_transform.origin.y + area.row * 0.1
			var yy = y + 0.1
			
			if columnHand >= x && columnHand <= xx && rowHand >= y && rowHand <= yy:
				# print(area.column)
				enterArea(area.row, area.column)		