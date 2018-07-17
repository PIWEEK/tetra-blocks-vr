extends Spatial

var cube = load("res://Cube.tscn")

func create(type):
	var cubes = [
		cube.instance(),
		cube.instance(),
		cube.instance(),
		cube.instance()
	]
	
	var node = KinematicBody.new()
	node.set('collision/safe_margin', 0.000001)
	
	if type == 's':
		figureS(cubes)
	elif type == 'j':
		figureJ(cubes)
		
	add_child(node)
	
	for cube in cubes: 
		var collision = CollisionShape.new()
		var shape = BoxShape.new()
		
		collision.shape = shape
		collision.translation = cube.translation
		node.add_child(collision)
	
	createCubes(node, cubes)
	
	return node

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
		var material = SpatialMaterial.new()
		material.albedo_color = color
		cube.get_node('MeshInstance').set_surface_material(0, material)
		
func applyTranslation(cubes, translations):
	for index in range(cubes.size()):
		cubes[index].translation = translations[index]

func createCubes(node, cubes):
	for cube in cubes:
		node.add_child(cube)	
	
func position(row, column):
	var position  = Vector3(0, 0, 0)
	
	position.x = 2 * column
	position.y = -(2 * row)
	
	return position