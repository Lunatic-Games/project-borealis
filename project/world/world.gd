extends Spatial

const CHUNK_BUFFER = 5.0  # Distance after chunk to wait before swapping

onready var front_chunk = $Chunk2
onready var back_chunk = $Chunk
onready var camera = $Camera
onready var viewport_size = get_viewport().size

# Generate world
func _ready():
	front_chunk.generate()
	back_chunk.generate()

# Move camera forwards and update chunks if needed
func _physics_process(_delta):
	# Calculate front of chunk + CHUNK_BUFFER
	var back_chunk_pos = (back_chunk.transform.origin 
		- Vector3(0, 0, back_chunk.size.y / 2.0 + CHUNK_BUFFER))
		
	# Determine if that position is behind the camera view
	if camera.unproject_position(back_chunk_pos).y > viewport_size.y:
		# Swap chunks
		back_chunk.translation.z -= back_chunk.size.y * 2
		back_chunk.generate()
		var last_fronk = front_chunk
		front_chunk = back_chunk
		back_chunk = last_fronk
