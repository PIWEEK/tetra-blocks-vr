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
	
	if(rightHand.is_button_pressed(1)):
		print("1")
		
	if(rightHand.is_button_pressed(2)):
		print("2")
		
	if(rightHand.is_button_pressed(3)):
		print("3")
		
	if(rightHand.is_button_pressed(4)):
		print("4")
		
	if(rightHand.is_button_pressed(5)):
		print("5")
