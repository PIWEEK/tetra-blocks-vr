extends Spatial

var figure = load("res://Figure.tscn")
const SPEED = -0.5
var testCount = 0;
const INITIAL_POSITION = {
	"row": 8,
	"column": 1
}

var enableSpawn = true
var matrix = []

func _ready():	
	for row in range(0, 10):
		matrix.append([])
		for column in range(0, 20):
			matrix[row].append(null)
			createArea(row, column)
			
	addFigure('o', INITIAL_POSITION.row, INITIAL_POSITION.column)
	
	get_node("Timer").connect("timeout", self, "spawn")
	get_node("Timer2").connect("timeout", self, "move")

func addFigure(type, initialRow, initialColumn):
	enableSpawn = false
	var figureNode = figure.instance()
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
					"cube": currentFigure
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
	area.translation.x = 0.2 * row
	area.translation.y = 0.2 * column
	
	var collision = CollisionShape.new()
	collision.scale_object_local(Vector3(0.1, 0.1, 0.1))
	collision.shape = BoxShape.new()
	area.add_child(collision)
	
	add_child(area)
	
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
				
			
func spawn():
	if enableSpawn:
		addFigure('t', INITIAL_POSITION.row, INITIAL_POSITION.column)
		
		# test remove
		# if testCount == 2:
		#	removeFilledLines()
		# testCount = testCount + 1
		
		
		