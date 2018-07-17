extends Spatial

var figure = load("res://Figure.tscn")

func _ready():
	var figureNode = figure.instance()
	add_child(figureNode)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
