extends Spatial

var figure = load("res://Figure.tscn")
var count = 0;
var nodes = []
var SPEED = -0.5

func _ready():
	get_node("Timer").connect("timeout", self, "interval")

func interval():
	if	(count < 3):
		var figureNode = figure.instance()
					
		add_child(figureNode)
		
		if (count == 1):
			figureNode.translation = Vector3(-0.20, 0, 0)
			nodes.append(figureNode.create('s'))
		elif count == 0:
			nodes.append(figureNode.create('s'))
		elif count == 2:
			figureNode.translation = Vector3(-0.20, 0, 0)
			figureNode.rotation_degrees = Vector3(0, 0, 90)
			nodes.append(figureNode.create('j'))
			
	
	count = count + 1
	
func _physics_process(delta):
	for node in nodes:
		var relVec = Vector3(0, SPEED, 0) * delta
		
		var collision = node.move_and_collide(relVec)
		
		# if collision:
		# 	print(node.id)