extends Spatial

var figure = load("res://Figure.tscn")
const SPEED = -0.5
var testCount = 0;
const INITIAL_POSITION = {
	"row": 8,
	"column": 1
}

var figureNode = figure.instance()
var enableSpawn = true
var matrix = []
var areas = []
var dropCandidateBlocks = []
var dropCandidateMatrix
var dropInProgress = false
var currentDropCandidate
var oldDropCandidate

func _ready():	
	for row in range(0, 10):
		matrix.append([])
		for column in range(0, 20):
			matrix[row].append(null)
			createArea(row, column)
			
	addFigure('o', INITIAL_POSITION.row, INITIAL_POSITION.column)
	
	get_node("Timer").connect("timeout", self, "spawn")
	get_node("Timer2").connect("timeout", self, "move")
	
	get_node('/root/Main').addMatrix(matrix)

func addFigure(type, initialRow, initialColumn):
	enableSpawn = false
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

func move():
	if !canMove():
		disableCurrent()
		enableSpawn = true
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
		print(row, ' | ', column)
		currentDropCandidate = {
			"row": row,
			"column": column	
		}
		
#	var areaFinded = null
#
#	for area in areas:
#		if area.node == areaEnterd:
#			areaFinded = area


func removeCurrent():
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			if node && node.current:
				node.cube.get_parent().remove_child(node.cube)
				matrix[row][column] = null

# todo 
func removeFilledLines():
	for column in range(matrix[0].size()):
		var node = matrix[0][column]
		
		if node:
			node.cube.get_parent().remove_child(node.cube)
			matrix[0][column] = null
			
	for row in range(matrix.size()):
		for column in range(matrix[row].size()):
			var node = matrix[row][column]
			
			if node:
				var newRow = row - 1
				
				matrix[newRow][column] = node
				matrix[row][column] = null;
				
				moveFigure(node.cube, newRow, column)

func dropCandidate(type, initialRow, initialColumn):
	removeCurrent()
	enableSpawn = false
	dropInProgress = true
	
	if dropCandidateBlocks.size():
		var count = 0
		print(initialRow, ' | ', initialColumn);
		
		for row in range(dropCandidateMatrix.size()):
			for column in range(dropCandidateMatrix[row].size()):
				if dropCandidateMatrix[row][column]:
					var currentRow = row + initialRow
					var currentColumn = column + initialColumn
					var currentFigure = dropCandidateBlocks[count]
					
					count = count + 1
					moveFigure(currentFigure.cube, currentRow, currentColumn)
	else:
		var figureData = figureNode.create(type) 
		figureData.matrix.invert()
		
		dropCandidateMatrix = figureData.matrix
		
		for row in range(figureData.matrix.size()):
			for column in range(figureData.matrix[row].size()):
				if figureData.matrix[row][column]:
					var currentRow = row + initialRow
					var currentColumn = column + initialColumn
					var currentFigure = figureData.cubes.pop_front()
					
					currentFigure.get_node('CollisionShape').get_parent().remove_child(currentFigure.get_node('CollisionShape'))
	
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
				
func confirmDropCandidate():
	for currentBlockCandidate in dropCandidateBlocks:
		matrix[currentBlockCandidate.row][currentBlockCandidate.column] = {
			"current": true,
			"cube": currentBlockCandidate.cube,
			"type": currentBlockCandidate.type
		}
		
	dropCandidateBlocks = []
	enableSpawn = true
	dropInProgress = false
				
func deleteDropCandidate():
	for it in dropCandidateBlocks:
		remove_child(it.cube);
		
	enableSpawn = true
	dropInProgress = false

func spawn():
	if enableSpawn:
		addFigure('t', INITIAL_POSITION.row, INITIAL_POSITION.column)
			
		testCount = testCount + 1
		
func _process(delta):		
	if currentDropCandidate && (!oldDropCandidate || (currentDropCandidate.row != currentDropCandidate.row || currentDropCandidate.column != oldDropCandidate.column)):
		dropCandidate('s', currentDropCandidate.row, currentDropCandidate.column)
		
		oldDropCandidate = {
			"row": currentDropCandidate.row,
			"column": currentDropCandidate.column
		}