extends Spatial

var globalMatrix = []
var globalDrag = null
var activeMatrix = null
var activePlayArea = null
var figures = {
	"PlayArea": null
}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func addMatrix(matrix):
	globalMatrix.append(matrix)
	
func getMatrix():
	return globalMatrix
	
func setActiveMatrix(matrix):
	activeMatrix = matrix

func getActiveMatrix():
	return activeMatrix
	
func setActivePlayArea(playArea):
	activePlayArea = playArea

func getActivePlayArea():
	return activePlayArea	
	
func addDrag(type):
	globalDrag = {
		"type": type	
	}
	
func removeDrag(type):
	globalDrag = null
	
func getDrag():
	return globalDrag
	
func addFigure(name, figure):
	figures[name] = figure
	
func getFigures():
	return figures