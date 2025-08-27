extends MeshInstance3D

@export var amplitude : float = 5.0
@export var frequency_large : float = 0.01
@export var frequency_small : float = 0.5
@export var noise_large : FastNoiseLite
@export var noise_small : FastNoiseLite


@onready var collider = $"../MeshInstance3D"
@onready var snow: GPUParticles3D = $"../Snow"


var biome_colors := {
	0: Color(0.2, 0.3, 0.2),   # pantano (swampy dark green)
	1: Color(0.8, 0.7, 0.6),   # meseta (plateau, sandy brown)
	2: Color(0.8, 0.2, 0.2),   # inferno (fiery red)
	3: Color(0.5, 0.2, 0.2),   # volcano (dark lava red)
	4: Color(0.0, 0.6, 0.2),   # jungle (lush green)
	5: Color(0.0, 0.4, 0.0),   # forest (dark green)
	6: Color(0.7, 0.9, 1.0),   # ice (light blue)
	7: Color(1.0, 1.0, 1.0),   # snow (white)
	8: Color(1.0, 0.9, 0.4),   # desert (yellow)
	9: Color(0.3, 0.0, 0.5)    # end (purple)
}


func falloff(x: float, z: float, world_width: float, world_height: float) -> float:
	# normalize to [0,1]
	var nx = x / (world_width - 5)
	var nz = z / (world_height - 5)

	# remap to [-1,1] around center
	nx = nx * 2.0 - 1.0
	nz = nz * 2.0 - 1.0

	# distance from center
	var d = sqrt(nx * nx + nz * nz)

	# smooth fade, tweak exponent to control softness
	var fall = clamp(1.0 - pow(d, 2.0), -1.0, 1.0)
	return fall


func get_biome_color(height: float, shadow: float) -> Color:
	# ---- Gradient control points ----
	var points = [
		Vector2(-1.0, 0), 
		Vector2(0.0, 1), 
		Vector2(0.3, 2),
		Vector2(2.0, 3),  
		Vector2(4.5, 4)   
	]

	var palette = [
		Color(0.0, 0.2, 0.9), 
		Color(1.0, 0.9, 0.4),  
		Color(0.2, 0.5, 0.2),  
		Color(0.05, 0.05, 0.05),  
		Color(0.3, 0.6, 1.0)  
	]

	# ---- Pick color by interpolating between control points ----
	var base_color: Color

	if height <= points[0].x:
		base_color = palette[points[0].y]
	elif height >= points[-1].x:
		base_color = palette[points[-1].y]
	else:
		for i in range(points.size() - 1):
			var h0 = points[i].x
			var h1 = points[i + 1].x
			if height >= h0 and height <= h1:
				var t = (height - h0) / (h1 - h0) # blend factor
				base_color = palette[points[i].y].lerp(palette[points[i + 1].y], t)
				break
				
	if not (height < points[2][0] and height > -0.7):
		var shadow_strength = clamp((shadow + 1.0) * 0.5, 0.0, 1.0)
		shadow_strength = 1.0 - shadow_strength
		shadow_strength *= 1.3

		# Extract HSV from the color
		var h: float = base_color.h
		var s: float = base_color.s
		var v: float = base_color.v

		# Apply tweaks
		v = clamp(v * (1.0 - 0.7 * shadow_strength), 0.0, 1.0)
		s = clamp(s * (1.0 + 0.3 * shadow_strength), 0.0, 1.0)

		# Rebuild color
		base_color = Color.from_hsv(h, s, v, base_color.a)
	return base_color


const TILE_SIZE := 5.0

func _ensure_noises() -> void:
	if noise_large == null:
		noise_large = FastNoiseLite.new()
		noise_large.noise_type = FastNoiseLite.TYPE_PERLIN
		noise_large.frequency = frequency_large
	if noise_small == null:
		noise_small = FastNoiseLite.new()
		noise_small.noise_type = FastNoiseLite.TYPE_PERLIN
		noise_small.frequency = frequency_small

func get_height(global_x: float, global_z: float, map_width_tiles: int, map_height_tiles: int) -> float:
	_ensure_noises()
	var map_world_width  = float(map_width_tiles)  * TILE_SIZE
	var map_world_height = float(map_height_tiles) * TILE_SIZE

	var base_height = noise_large.get_noise_2d(global_x, global_z) * (amplitude * 10.0)
	var detail      = noise_small.get_noise_2d(global_x, global_z) * (amplitude * 0.4)
	var h = base_height + detail

	var mask = falloff(global_x, global_z, map_world_width, map_world_height)
	if mask < 0.0:
		mask *= 5.0
	h *= mask
	if mask < 0.0:
		h = mask  
	h += 0.43                      # or: h = 0.0 if you want sea level outside island
	return h


func generate_geometry(x, y, map_width, map_height):
	var medium = 0.0
	
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

	# Prepare color array same size as vertices
	var colors := PackedColorArray()
	colors.resize(vertices.size())


	for i in range(vertices.size()):
		var v = vertices[i]
		var world_x = v.x + chunk_origin.x
		var world_z = v.z + chunk_origin.z

		# noises
		var base_height = noise_large.get_noise_2d(world_x, world_z) * (amplitude * 10)
		var detail = noise_small.get_noise_2d(world_x, world_z) * (amplitude * 0.4)
		var height = base_height + detail

		# apply falloff (island effect)
		var mask = falloff(world_x, world_z, map_world_width, map_world_height)
		if mask < 0:
			mask *= 5
		
		height *= mask
		if mask < 0:
			height = mask

		v.y = height
		vertices[i] = v
		medium += height
		colors[i] = get_biome_color(height, detail)

	mesh_data[Mesh.ARRAY_COLOR] = colors
	medium = medium / vertices.size()

	# Put vertices back into mesh data
	mesh_data[Mesh.ARRAY_VERTEX] = vertices

	# Create a new ArrayMesh with the modified vertices
	var new_mesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)

	# Assign the new mesh to the MeshInstance3D
	mesh = new_mesh

	return medium


func generate_biome(seed_value: int, x, y, map_width, map_height, height):
	# Create a seeded RNG
	
	height = int(height)
	
	if (height > 2):
		snow.emitting = true
	# make a new material with the biome color
	var mat := StandardMaterial3D.new()
	#mat.albedo_color = biome_colors[number]

	mat.vertex_color_use_as_albedo = true
	# assign it to this mesh
	set_surface_override_material(0, mat)
	
	collider.global_position = Vector3(collider.global_position.x, height, collider.global_position.z)
	snow.global_position = collider.global_position
	snow.global_position.y += 1
	mat.emission_enabled = false
	mat.emission = Color(0.4, 0.4, 0.4)

	
func generate_terrain(x, y, map_width, map_height):
	generate_biome(x * map_width + y, x, y, map_width, map_height, generate_geometry(x, y, map_width, map_height))
	
	
func get_height_at(x, z) -> float:

	return 0.0 
