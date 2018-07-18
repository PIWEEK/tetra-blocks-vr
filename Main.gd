extends Spatial

var globalMatrix = []
var globalDrag = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func addMatrix(matrix):
	globalMatrix.append(matrix)
	
func getMatrix():
	return globalMatrix
	
func getPlayArea():
	return get_node("PlayArea")
	
func addDrag(type):
	globalDrag = {
		"type": type	
	}
	
func removeDrag(type):
	globalDrag = null
	
func getDrag():
	return globalDrag