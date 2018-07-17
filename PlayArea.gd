extends Spatial

var figure = load("res://Figure.tscn")
var count = 0;
var nodes = []
const SPEED = -0.5

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
			
	if count == 5:
		test1()
	
	count = count + 1
	
func _physics_process(delta):
	for node in nodes:
		var relVec = Vector3(0, SPEED, 0) * delta
		
		var collision = node.move_and_collide(relVec)
		
		# if collision:
		# 	print(node.id)
		
func test1():
	var node = nodes[nodes.size() - 1]
	var children = node.get_children()
	
	var cubes = []
	var collisions = []
	
	for child in children:
		if child is CollisionShape:
			collisions.append(child)
		else:
			cubes.append(child)
			
	node.remove_child(cubes[0])
	node.remove_child(collisions[0])