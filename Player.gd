extends ARVROrigin
signal moveViewToRight

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var vr = ARVRServer.find_interface("OpenVR")
	if(vr and vr.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false

func _process(delta):
	var rightHand = get_node("RightHand");
	
	if(rightHand.is_button_pressed(1)):
		print("1")
		
	# grid
	if(rightHand.is_button_pressed(2)): 
		print("2")
		
	if(rightHand.is_button_pressed(3)):
		print("3")
		
	if(rightHand.is_button_pressed(4)):
		print("4")
		
	if(rightHand.is_button_pressed(5)):
		print("5")
		
	if(rightHand.is_button_pressed(6)):
		print("6")

	if(rightHand.is_button_pressed(7)):
		print("7")

	if(rightHand.is_button_pressed(8)):
		print("8")

	if(rightHand.is_button_pressed(9)):
		print("9")

	if(rightHand.is_button_pressed(10)):
		print("10")

func _input(event):
	if Input.is_action_pressed("ui_right"):
		emit_signal("moveViewToRight")

func _on_PlayerOrigin_moveViewToRight():
	var angle = self.rotation_degrees.y
	if(angle < 360):
		self.rotation_degrees = Vector3(0, angle - 45, 0)
	else:
		self.rotation_degrees = Vector3(0, 0, 0)
