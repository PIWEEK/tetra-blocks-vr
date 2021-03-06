extends ARVROrigin
signal moveViewToRight

var figureScene = load("res://Figure.tscn").instance()
var main
var rightHand
var currentBody

signal throw

var piecesNames = ['s', 'i', 'j', 'l', 't', 'z', 'o']
var pieces = {
	"s": null,
	"i": null,
	"j": null,
	"l": null,
	"t": null,
	"z": null,
	'o': null
}

func _ready():
	# print('ready')
	main = get_node("/root/Main")
	
	var vr = ARVRServer.find_interface("OpenVR")
	if(vr and vr.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false
	
	rightHand = get_node("RightHand");
	rightHand.connect("button_pressed", self, "buttonPressed")
	rightHand.connect("button_release", self, "buttonRelease")
	
	rightHand.get_node("Area").connect("body_entered", self, "_on_body_enter")
	
	pieces['s'] = get_node("ARVRCamera/currentPieces/s")
	pieces['i'] = get_node("ARVRCamera/currentPieces/i")
	pieces['j'] = get_node("ARVRCamera/currentPieces/j")
	pieces['l'] = get_node("ARVRCamera/currentPieces/l")
	pieces['t'] = get_node("ARVRCamera/currentPieces/t")
	pieces['o'] = get_node("ARVRCamera/currentPieces/o")
	pieces['z'] = get_node("ARVRCamera/currentPieces/z")
	
	hideAllPieces()
	
func hideAllPieces():
	for name in piecesNames:
		pieces[name].visible = false

func _on_body_enter(body):
	currentBody = body
	# print('_on_body_enter', currentBody)
	
func _process(delta):
	if main:
		var currentFigures = main.getFigures()
		
		hideAllPieces()
		
		if currentFigures['PlayArea']:
			pieces[currentFigures['PlayArea']].visible = true
	
func buttonPressed(id):	
	# print('buttonPressed')
	if (id == 2 && currentBody):
		pick()
		
	if (id == 7): 
		main.startGame()
		
	if (id == 1):
		togglePause()
	
func togglePause():
	if get_tree().paused:
		$ARVRCamera/Music.play()
		get_tree().paused = false
	else:
		$ARVRCamera/Music.stop()
		get_tree().paused = true
	
func buttonRelease(id):
	if (id == 2 && currentBody):
		# print('release!!')
		throw()	
	
func pick():
	if (currentBody && rightHand.get_node("Figure").get_child_count() == 0):
		var mainScene = get_node('/root/Main')
		var matrix = mainScene.getActiveMatrix()
		var activeArea = mainScene.getActivePlayArea()
		
		var rowFinded = null
		var columnFinded = null
		
		for row in range(matrix.size()):
			for column in range(matrix[row].size()):
				var node = matrix[row][column]
				
				if node && node.cube == currentBody && node.current:
					rowFinded = row
					columnFinded = column
					
		var handFigure = rightHand.get_node("Figure")
	
		if rowFinded && columnFinded:
			var type = matrix[rowFinded][columnFinded].type

			main.addDrag(type)
		
			var handCubes = figureScene.create(type)
			handCubes.matrix.invert()
			
			for cube in handCubes.cubes:
				cube.get_node('MeshInstance').get_surface_material(0).albedo_color.a = 0.2
			
			for row in range(handCubes.matrix.size()):
				for column in range(handCubes.matrix[row].size()):
					if handCubes.matrix[row][column]:
						var currentFigure = handCubes.cubes.pop_front()

						handFigure.add_child(currentFigure)
						currentFigure.scale_object_local(Vector3(0.1, 0.1, 0.1))
						currentFigure.translation.x = 0.2 * column
						currentFigure.translation.y = 0.2 * row
		
			if type == 's':
				handFigure.translation = Vector3(-0.1, -0.1, 0)
			elif type == 'j':
				handFigure.translation = Vector3(-0.08, 0, 0)
			elif type == 'i':
				handFigure.translation = Vector3(-0.15, 0, 0)
			elif type == 't':
				handFigure.translation = Vector3(-0.1, -0.1, 0)
			elif type == 'l':
				handFigure.translation = Vector3(-0.08, 0, 0)
			elif type == 'o':
				handFigure.translation = Vector3(-0.1, -0.1, 0)
			elif type == 'z':
				handFigure.translation = Vector3(-0.1, 0, 0)
			
			if activeArea:
				activeArea.removeCurrent()
				activeArea.enableSpawn()
		
func throw():
	if (rightHand.get_node("Figure").get_child_count() > 0):
		# print("throw")
		emit_signal("throw")
		
		for i in rightHand.get_node("Figure").get_children():
			i.queue_free()
			
		main.removeDrag()

func _input(event):
	if Input.is_action_pressed("ui_right"):
		emit_signal("moveViewToRight")

func _on_PlayerOrigin_moveViewToRight():
	pass
#	var angle = self.rotation_degrees.y
#	if(angle < 360):
#		self.rotation_degrees = Vector3(0, angle - 45, 0)
#	else:
#		self.rotation_degrees = Vector3(0, 0, 0)
