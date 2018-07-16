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

	rightHand.connect("button_pressed", self, buttonPressed)

	# grid
	if(rightHand.is_button_pressed(2)): 
		print("2")

func buttonPressed(id):
	print(id)

func _input(event):
	if Input.is_action_pressed("ui_right"):
		emit_signal("moveViewToRight")

func _on_PlayerOrigin_moveViewToRight():
	var angle = self.rotation_degrees.y
	if(angle < 360):
		self.rotation_degrees = Vector3(0, angle - 45, 0)
	else:
		self.rotation_degrees = Vector3(0, 0, 0)
