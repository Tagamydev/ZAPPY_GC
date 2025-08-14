extends MeshInstance3D

@export var amplitude : float = 5.0
@export var frequency : float = 0.5
@export var noise : FastNoiseLite

func generate_terrain():
	if not noise:
		noise = FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.TYPE_PERLIN
		noise.frequency = frequency

	# Get the chunk's world position
	var chunk_origin = global_transform.origin

	# Get the arrays from the original mesh
	var mesh_data = mesh.surface_get_arrays(0)
	var vertices = mesh_data[Mesh.ARRAY_VERTEX]

	# Modify vertex heights based on world position
	for i in range(vertices.size()):
		var v = vertices[i]
		var world_x = v.x + chunk_origin.x
		var world_z = v.z + chunk_origin.z
		v.y = noise.get_noise_2d(world_x * frequency, world_z * frequency) * amplitude
		if v.y < 0:
			v.y = 0
		vertices[i] = v

	# Put vertices back into mesh data
	mesh_data[Mesh.ARRAY_VERTEX] = vertices

	# Create a new ArrayMesh with the modified vertices
	var new_mesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)

	# Assign the new mesh to the MeshInstance3D
	mesh = new_mesh
