extends Spatial

var cube = load("res://Cube.tscn")

func _ready():
	var cubes = [
		cube.instance(),
		cube.instance(),
		cube.instance(),
		cube.instance()
	]
	
	figureZ(cubes)
	createCubes(cubes)
		
func figureI(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(0, 3)
	])
	
func figureJ(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(1, 2)
	])
	
func figureL(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(1, 0)
	])
	
func figureO(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(1, 0),
		position(1, 1)
	])
	
func figureS(cubes):
	applyTranslation(cubes, [
		position(1, 0),
		position(1, 1),
		position(0, 1),
		position(0, 2)
	])
	
func figureT(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(0, 2),
		position(1, 1)
	])
	
func figureZ(cubes):
	applyTranslation(cubes, [
		position(0, 0),
		position(0, 1),
		position(1, 1),
		position(1, 2)
	])

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
