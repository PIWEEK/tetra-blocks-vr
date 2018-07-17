extends Spatial

var cube = load("res://Cube.tscn")

func _ready():
	var cubes = [
		cube.instance(),
		cube.instance(),
		cube.instance(),
		cube.instance()
	]
	
	figureO(cubes)
	createCubes(cubes)
		
func figureI(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(0, 3)
	])
	
	applyColor(cubes, '00FFFF')
	
func figureJ(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(1, 2)
	])
	
	applyColor(cubes, '0000FF')
	
func figureL(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(1, 0)
	])
	
	applyColor(cubes, 'FFA500')
	
func figureO(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(1, 0),
		position(1, 1)
	])
	
	applyColor(cubes, 'FFFF00')
	
func figureS(cubes):
	applyTranslation(cubes, [
		position(1, 0),
		position(1, 1),
		position(0, 1),
		position(0, 2)
	])
	
	applyColor(cubes, '00FF00')
	
func figureT(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(1, 1)
	])
	
	applyColor(cubes, '80080')
	
func figureZ(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(1, 1),
		position(1, 2)
	])
	
	applyColor(cubes, 'FF0000')
	
func applyColor(cubes, color):
	for cube in cubes:
		cube.get_node('Area/MeshInstance').get_surface_material(0).albedo_color = color
		
func applyTranslation(cubes, translations):
	for index in range(cubes.size()):
		cubes[index].translation = translations[index]

func createCubes(cubes):
	for cube in cubes:
		add_child(cube)	
	
func position(row, column):
	var position  = Vector3(0, 0, 0)
	
	position.x = 2 * column
	position.y = -(2 * row)
	
	return position

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
