extends Spatial

const CHUNK_LENGTH = 60.0
const CAMERA_MOVE_SPEED = 1.0

onready var camera_start_z = $Camera.translation.z
onready var front_chunk = $Chunk2
onready var back_chunk = $Chunk

func _physics_process(delta):
	$Camera.translation.z -= CAMERA_MOVE_SPEED * delta
	if camera_start_z - $Camera.translation.z > CHUNK_LENGTH:
		camera_start_z -= CHUNK_LENGTH
		back_chunk.translation.z -= CHUNK_LENGTH * 2
		var last_fronk = front_chunk
		front_chunk = back_chunk
		back_chunk = last_fronk
