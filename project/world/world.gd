extends Spatial

const CHUNK_LENGTH = 60.0
const CAMERA_MOVE_SPEED = 1.0

onready var camera_start_z = $Camera.translation.z
onready var front_chunk = $Chunk2
onready var back_chunk = $Chunk
onready var camera = $Camera

func _ready():
	var player_pos = $Player.translation
	$Chunk.generate_resources()
	$Chunk2.generate_resources()


func _physics_process(delta):
	camera.translation.z -= CAMERA_MOVE_SPEED * delta
	if camera_start_z - camera.translation.z > CHUNK_LENGTH:
		camera_start_z -= CHUNK_LENGTH
		back_chunk.translation.z -= CHUNK_LENGTH * 2
		back_chunk.snow.reset_path()
		back_chunk.generate_resources()
		var last_fronk = front_chunk
		front_chunk = back_chunk
		back_chunk = last_fronk
