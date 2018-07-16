extends ARVROrigin
signal moveViewToRight

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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
	rightHand.connect("button_release", self, "buttonRelease")
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
	
func buttonRelease(id):
	if (id == 2 && currentBody):
		throw()	
	
func pick():
	if (rightHand.get_node("Figure").get_child_count() == 0):
		print('---->', currentBody.get_mode())
		oldParent = currentBody.get_parent()
		oldParent.remove_child(currentBody)
		
		print("pick")
		currentBody.translation = Vector3(0, 0, 0)
		currentBody.rotation_degrees = Vector3(0, 0, 0)
		
		currentBody.set_mode(1)
		rightHand.get_node("Figure").add_child(currentBody)
		# child.set_owner(rightHand)
	
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
