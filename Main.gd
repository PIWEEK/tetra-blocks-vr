extends Spatial

var globalMatrix = []
var globalDrag = null
var activeMatrix = null
var activePlayArea = null
var figures = {
	"PlayArea": null
}
var game = load("res://Game.tscn")
var currentGameNode

func _ready():
    set_process_input(true)
	
#	self.get_node('Spatial/PlayArea').queue_free()
#	self.get_node('Spatial/PlayArea4').queue_free()
#	self.get_node('Spatial/PlayArea3').queue_free()
#	self.get_node('Spatial/PlayArea2').queue_free()	


func _input(event):
	if event.is_action_pressed("ui_accept"): 
		startGame()

func generateGame():
	currentGameNode = game.instance()
	add_child(currentGameNode)
	$PlayerOrigin.get_node("ARVRCamera/Music").play()
		
func startGame():
	if !currentGameNode: 
		generateGame()
	else:
		$PlayerOrigin.get_node("ARVRCamera/Music").stop()
		currentGameNode.queue_free()
		generateGame()
	
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
	
func removeDrag():
	globalDrag = null
	
func getDrag():
	return globalDrag
	
func addFigure(name, figure):
	figures[name] = figure
	
func getFigures():
	return figures