extends Spatial

var globalMatrix = []
var globalDrag = null
var activeMatrix = null
var activePlayArea = null
var figures = {
	"PlayArea": null
}
var game = load("res://Game.tscn")
var game_started = false

func _ready():
    set_process_input(true)
	
#	self.get_node('Spatial/PlayArea').queue_free()
#	self.get_node('Spatial/PlayArea4').queue_free()
#	self.get_node('Spatial/PlayArea3').queue_free()
#	self.get_node('Spatial/PlayArea2').queue_free()	


func _input(event):
	if event.is_action_pressed("ui_accept"): 
		startGame()
		
func startGame():
	if !game_started: 
		add_child(game.instance())
		game_started = true
	
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