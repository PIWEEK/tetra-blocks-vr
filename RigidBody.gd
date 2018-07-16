extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var bodies = get_colliding_bodies()
	
	if (bodies.size() > 0):
		print(bodies)