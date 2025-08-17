extends MeshInstance3D

@export var amplitude : float = 5.0
@export var frequency_large : float = 0.01
@export var frequency_small : float = 0.5
@export var noise_large : FastNoiseLite
@export var noise_small : FastNoiseLite


var biome_colors := {
	0: Color(0.7, 0.9, 1.0),   # ice (light blue)
	1: Color(1.0, 1.0, 1.0),   # snow (white)
	2: Color(0.2, 0.3, 0.2),   # pantano (swampy dark green)
	3: Color(0.8, 0.7, 0.6),   # meseta (plateau, sandy brown)
	4: Color(0.8, 0.2, 0.2),   # inferno (fiery red)
	5: Color(0.5, 0.2, 0.2),   # volcano (dark lava red)
	6: Color(0.0, 0.6, 0.2),   # jungle (lush green)
	7: Color(1.0, 0.9, 0.4),   # desert (yellow)
	8: Color(0.0, 0.4, 0.0),   # forest (dark green)
	9: Color(0.3, 0.0, 0.5)    # end (purple)
}

func falloff(x: float, z: float, world_width: float, world_height: float) -> float:
	# normalize to [0,1]
	var nx = x / world_width
	var nz = z / world_height

	# remap to [-1,1] around center
	nx = nx * 2.0 - 1.0
	nz = nz * 2.0 - 1.0

	# distance from center
	var d = sqrt(nx * nx + nz * nz)

	# smooth fade, tweak exponent to control softness
	var fall = clamp(1.0 - pow(d, 2.0), 0.0, 1.0)
	return fall



func generate_geometry(x, y, map_width, map_height):
	if not noise_large:
		noise_large = FastNoiseLite.new()
		noise_large.noise_type = FastNoiseLite.TYPE_PERLIN
		noise_large.frequency = frequency_large

	if not noise_small:
		noise_small = FastNoiseLite.new()
		noise_small.noise_type = FastNoiseLite.TYPE_PERLIN
		noise_small.frequency = frequency_small	

	# Get the chunk's world position
	var chunk_origin = global_transform.origin

	# Get the arrays from the original mesh
	var mesh_data = mesh.surface_get_arrays(0)
	var vertices = mesh_data[Mesh.ARRAY_VERTEX]

	var tile_size = 5.0
	var map_world_width = map_width * tile_size
	var map_world_height = map_height * tile_size

	for i in range(vertices.size()):
		var v = vertices[i]
		var world_x = v.x + chunk_origin.x
		var world_z = v.z + chunk_origin.z

		# noises
		var base_height = noise_large.get_noise_2d(world_x, world_z) * (amplitude * 10)
		var detail = noise_small.get_noise_2d(world_x, world_z) * (amplitude * 0.3)
		var height = base_height + detail

		# apply falloff (island effect)
		var mask = falloff(world_x, world_z, map_world_width, map_world_height)
		height *= mask

		v.y = height
		vertices[i] = v


	# Put vertices back into mesh data
	mesh_data[Mesh.ARRAY_VERTEX] = vertices

	# Create a new ArrayMesh with the modified vertices
	var new_mesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)

	# Assign the new mesh to the MeshInstance3D
	mesh = new_mesh
	


func generate_biome(seed_value: int):
	# Create a seeded RNG
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	# Get a random number between 0 and 9, based on that seed
	var number = rng.randi_range(0, 9)


	# make a new material with the biome color
	var mat := StandardMaterial3D.new()
	mat.albedo_color = biome_colors[number]

	# assign it to this mesh
	set_surface_override_material(0, mat)

	print("Biome set to:", number)

	
func generate_terrain(x, y, map_width, map_heigth):
	generate_geometry(x, y, map_width, map_heigth)
	generate_biome(x * map_width + y)
	
