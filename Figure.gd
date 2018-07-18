extends Spatial

var cube = load("res://Cube.tscn")

func create(type):
	if type == 's':
		return figureS()
	elif type == 'j':
		return figureJ()
	elif type == 'i':
		return figureI()
	elif type == 't':
		return figureT()
	elif type == 'l':
		return figureL()
	elif type == 'o':
		return figureO()
	elif type == 'z':
		return figureZ()

func figureI():
	var cubes = instanceCubes()
	applyColor(cubes, '00FFFF')
	
	return {
		"matrix": [
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[1, 1, 1, 1]
		],
		"cubes": cubes
	}
	
func figureJ():
	var cubes = instanceCubes()
	applyColor(cubes, '0000FF')
	
	return {
		"matrix": [
			[0, 0, 0],
			[0, 0, 1],
			[1, 1, 1]
		],
		"cubes": cubes
	}
	
func figureL():
	var cubes = instanceCubes()
	applyColor(cubes, 'FFA500')
	
	return {
		"matrix": [
			[0, 0, 0],
			[1, 0, 0],
			[1, 1, 1]
		],
		"cubes": cubes
	}
	
func figureO():
	var cubes = instanceCubes()
	applyColor(cubes, 'FFFF00')
	
	return {
		"matrix": [
			[1, 1],
			[1, 1]
		],
		"cubes": cubes
	}
	
func figureS():
	var cubes = instanceCubes()
	applyColor(cubes, '00FF00')
	
	return {
		"matrix": [
			[0, 0, 0],
			[0, 1, 1],
			[1, 1, 0]
		],
		"cubes": cubes
	}	

func figureT():
	var cubes = instanceCubes()
	applyColor(cubes, 'aa00ff')
	
	return {
		"matrix": [
			[0, 0, 0],
			[1, 1, 1],
			[0, 1, 0]
		],
		"cubes": cubes
	}
	
func figureZ():
	var cubes = instanceCubes()
	applyColor(cubes, 'FF0000')
	
	return {
		"matrix": [
			[0, 0, 0],
			[1, 1, 0],
			[0, 1, 1]
		],
		"cubes": cubes
	}	
	
func applyColor(cubes, color):
	for cube in cubes:
		var material = SpatialMaterial.new()
		material.albedo_color = color
		cube.get_node('MeshInstance').set_surface_material(0, material)
	
func instanceCubes():
	return [
		cube.instance(),
		cube.instance(),
		cube.instance(),
		cube.instance()
	]