extends Spatial

var cube = load("res://Cube.tscn")
var colors = {
	's': Color(0, 255, 0, 1),
	'j': Color(0, 0, 255, 1),
	'i': Color(0, 255, 255, 1),
	't': Color(170, 0, 255, 1),
	'l': Color(255, 165, 0, 1),
	'o': Color(255, 255, 0, 1),
	'z': Color(255, 0, 0, 1)
}

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
	applyColor(cubes, colors['i'])
	
	return {
		"matrix": [
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[1, 1, 1, 1]
		],
		"cubes": cubes
	}
	
func figureJ():
	var cubes = instanceCubes()
	applyColor(cubes, colors['j'])
	
	return {
		"matrix": [
			[0, 0, 0],
			[1, 0, 0],
			[1, 1, 1]
		],
		"cubes": cubes
	}
	
func figureL():
	var cubes = instanceCubes()
	applyColor(cubes, colors['l'])
	
	return {
		"matrix": [
			[0, 0, 0],
			[0, 0, 1],
			[1, 1, 1]
		],
		"cubes": cubes
	}
	
func figureO():
	var cubes = instanceCubes()
	applyColor(cubes, colors['o'])
	
	return {
		"matrix": [
			[1, 1],
			[1, 1]
		],
		"cubes": cubes
	}
	
func figureS():
	var cubes = instanceCubes()
	applyColor(cubes, colors['s'])
	
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
	applyColor(cubes, colors['t'])
	
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
	applyColor(cubes, colors['z'])
	
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
		material.flags_transparent = true
		material.albedo_color = color
		cube.get_node('MeshInstance').set_surface_material(0, material)
	
func instanceCubes():
	return [
		cube.instance(),
		cube.instance(),
		cube.instance(),
		cube.instance()
	]