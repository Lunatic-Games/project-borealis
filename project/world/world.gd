extends Spatial

export (int, 1, 2) var number_of_players = 1

onready var front_chunk = $Chunk3
onready var middle_chunk = $Chunk2
onready var back_chunk = $Chunk
onready var camera = $Camera
onready var viewport_size = get_viewport().size

# Generate world
func _ready():
	front_chunk.generate()
	middle_chunk.generate()
	back_chunk.generate()
	if number_of_players == 1:
		$Player2.queue_free()
		$Player1.translation.x = 0.0
	for particles in $CanvasLayer/SnowOverlay.get_children():
		particles.restart()

# Check for pause
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		$CanvasLayer/PauseMenu.visible = true
		get_tree().set_input_as_handled()

# Move camera forwards and update chunks if needed
func _physics_process(_delta):
	# Calculate front of chunk + CHUNK_BUFFER
	var middle_chunk_pos = (middle_chunk.transform.origin 
		- Vector3(0, 0, middle_chunk.size.y / 2.0))
		
	# Determine if that position is behind the camera view
	if camera.unproject_position(middle_chunk_pos).y > viewport_size.y:
		# Swap chunks
		back_chunk.translation.z -= back_chunk.size.y * 3
		back_chunk.generate()
		var last_middle = middle_chunk
		middle_chunk = front_chunk
		front_chunk = back_chunk
		back_chunk = last_middle

func set_players(p1_device, p2_device):
	assert(p1_device or p2_device)
	if not p1_device:
		$Player1.device = p2_device
	else:
		$Player1.device = p1_device
		if p2_device:
			$Player2.device = p2_device
			number_of_players = 2

# Bring the camera to a stop once the day cycle is over
func _on_DayNightTimer_timeout():
	camera.stopping = true
