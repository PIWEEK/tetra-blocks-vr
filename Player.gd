extends ARVROrigin
signal moveViewToRight

var figureScene = load("res://Figure.tscn").instance()
var rightHand
var figure 
var currentBody
var oldParent 

func _ready():
	var vr = ARVRServer.find_interface("OpenVR")
	if(vr and vr.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false
	
	rightHand = get_node("RightHand");
	rightHand.connect("button_pressed", self, "buttonPressed")
	# rightHand.connect("button_release", self, "buttonRelease")
	figure = get_node("/root/Main/TestRigidBody")
	
	rightHand.get_node("Area").connect("body_entered", self, "_on_body_enter")

func _on_body_enter(body):
	currentBody = body
	
	print ("body enter", body.get_name())
	
func _process(delta):
	pass
	
func buttonPressed(id):	
	if (id == 2 && currentBody):
		pick()
	
#func buttonRelease(id):
#	if (id == 2 && currentBody):
#		throw()	
	
func pick():
	if (rightHand.get_node("Figure").get_child_count() == 0):
		var mainScene = get_node('/root/Main')
		var matrix = mainScene.getMatrix()[0]
	
		var rowFinded = null
		var columnFinded = null
		
		for row in range(matrix.size()):
			for column in range(matrix[row].size()):
				var node = matrix[row][column]
				
				if node && node.cube == currentBody && node.current:
					rowFinded = row
					columnFinded = column
				
		
		oldParent = currentBody.get_parent()
		var handFigure = rightHand.get_node("Figure")
	
		if rowFinded && columnFinded:
			var type = matrix[rowFinded][columnFinded].type
		
			var handCubes = figureScene.create(type)
			handCubes.matrix.invert()
			
			for row in range(handCubes.matrix.size()):
				for column in range(handCubes.matrix[row].size()):
					if handCubes.matrix[row][column]:
						var currentFigure = handCubes.cubes.pop_front()
						print('añado')
						handFigure.add_child(currentFigure)
						currentFigure.scale_object_local(Vector3(0.1, 0.1, 0.1))
						currentFigure.translation.x = 0.2 * column
						currentFigure.translation.y = 0.2 * row
				
		
		# todo: improve get center
		handFigure.translation = Vector3(-0.2, -0.2, 0)
		mainScene.getPlayArea().removeCurrent()
		
		print("pick")
	
func throw():
	if (currentBody):
		print("throw")
		currentBody.get_parent().remove_child(currentBody)
		
		currentBody.set_mode(0)
		print(rightHand.get_global_transform().origin)
		
		#currentBody.translation = Vector3(0, 0, 0)
		currentBody.translation = rightHand.get_global_transform().origin
		currentBody.rotation_degrees = rightHand.rotation_degrees
		oldParent.add_child(currentBody)
		
		print("new parent", oldParent.get_name())
		print("mode ", currentBody.get_mode())
		print("name ", currentBody.get_name())
				
		oldParent = null
		currentBody = null

func _input(event):
	if Input.is_action_pressed("ui_right"):
		emit_signal("moveViewToRight")

func _on_PlayerOrigin_moveViewToRight():
	var angle = self.rotation_degrees.y
	if(angle < 360):
		self.rotation_degrees = Vector3(0, angle - 45, 0)
	else:
		self.rotation_degrees = Vector3(0, 0, 0)
