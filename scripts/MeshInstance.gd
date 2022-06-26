extends MeshInstance

class_name ProceduralTerrain

export var SIZE=25

export var MAX_HEIGHT=5

export(Material) var mat

var vertices = PoolVector3Array()
var normals = PoolVector3Array()
var UVs = PoolVector2Array()

var noise1
var noise2
var noise3
var noise4

func _ready():
	randomize()
	# Plains
	noise1 = OpenSimplexNoise.new()
	noise2 = OpenSimplexNoise.new()
	
	
	# Hills
	noise3 = OpenSimplexNoise.new()
	noise4 = OpenSimplexNoise.new()
	
	# Generate terrain
	generateTerrain()
	
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	arrays[ArrayMesh.ARRAY_TEX_UV] = UVs
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(4, arrays)
	
	
	
	mesh = arr_mesh
	var material = SpatialMaterial.new()
	
	var texture = generateTexture()
	material.albedo_texture = texture
	
	
	print(texture.get_data().get_pixel(0,0))
	

	mesh.surface_set_material(0,material)

func generateTerrain() -> void:
	
	# Configure
	var nSeed= randi()
	
	# Noise 1 & 2 settings
	noise1.seed = nSeed
	noise1.octaves = 5
	noise1.period = 400.0
	noise1.persistence = 0.8
	
	noise2.seed = nSeed
	noise2.octaves = 5
	noise2.period = 45.0
	noise2.persistence = 0.5
	
	# Noise 3 & 4 settings
	noise3.seed = nSeed
	noise3.octaves = 5
	noise3.period = 30.0
	noise3.persistence = 0
	noise3.lacunarity = 0
	
	noise4.seed = nSeed
	noise4.octaves = 5
	noise4.period = 45.0
	noise4.persistence = 1
	noise4.lacunarity = 0
	
	
	print("Seed: "+str(noise1.seed))
	
	generateMesh()

func generateMesh():
	for x in range(SIZE):
		for y in range(SIZE):
			vertices.push_back(Vector3(x-1, noiseMixer(x-1,y-1), y-1))
			normals.push_back(vertices[vertices.size()-1].normalized())
			vertices.push_back(Vector3(x, noiseMixer(x,y-1), y-1))
			normals.push_back(vertices[vertices.size()-1].normalized())
			vertices.push_back(Vector3(x, noiseMixer(x,y), y))
			normals.push_back(vertices[vertices.size()-1].normalized())
			
			vertices.push_back(Vector3(x, noiseMixer(x,y), y))
			normals.push_back(vertices[vertices.size()-1].normalized())
			vertices.push_back(Vector3(x-1, noiseMixer(x-1,y), y))
			normals.push_back(vertices[vertices.size()-1].normalized())
			vertices.push_back(Vector3(x-1, noiseMixer(x-1,y-1), y-1))
			normals.push_back(vertices[vertices.size()-1].normalized())
			
			UVs.push_back(Vector2(0+x,0+y)/SIZE)
			UVs.push_back(Vector2(1+x,0+y)/SIZE)
			UVs.push_back(Vector2(1+x,1+y)/SIZE)
			
			UVs.push_back(Vector2(1+x,1+y)/SIZE)
			UVs.push_back(Vector2(0+x,1+y)/SIZE)
			UVs.push_back(Vector2(0+x,0+y)/SIZE)

func noiseMixer(x : int, y : int) -> int:
	return (noise1.get_noise_2d(x, y)+noise2.get_noise_2d(x, y))*MAX_HEIGHT+(clamp(noise3.get_noise_2d(x, y),0,INF)*MAX_HEIGHT+(clamp(noise3.get_noise_2d(x, y),noise3.get_noise_2d(x, y),INF)*MAX_HEIGHT))

func generateTexture() -> ImageTexture:
	var texture = ImageTexture.new()
	var img = Image.new()
	var color
	
	img.create(SIZE, SIZE, false, Image.FORMAT_RGB8)
	
	img.lock()
	# LET THE EDIT BEGIN
	for x in range(SIZE):
		for y in range(SIZE):
			var noiseLevel = noiseMixer(x,y)
			if noiseLevel >13:
				color = Color(110, 110, 110)/255
			elif noiseLevel>2:
				color = Color(34, 94, 35)/255
			elif noiseLevel>0.3:
				color = Color(46, 120, 65)/255
			else:
				color = Color(46, 110, 65)/255
			img.set_pixel(x,y, color)
	
	img.unlock()

	img.resize(SIZE*10, SIZE*10,0)
	
	
	
	texture.create_from_image(img)
	texture.storage = ImageTexture.STORAGE_RAW
	
	return texture
