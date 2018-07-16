extends ARVROrigin

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

