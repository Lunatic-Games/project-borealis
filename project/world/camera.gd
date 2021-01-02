extends Camera

signal stopped

const MOVE_SPEED = 6.0
const STOP_ACCELERATION = 0.05

export (Curve) var camera_speed  # Scales camera speed based on player depth

var distance_travelled = 0.0
var stopping = false
var current_speed = 0.0

onready var viewport_height = get_viewport().get_visible_rect().size.y

# Move camera forward every frame, scales with player depth
func _physics_process(delta):
	if stopping:
		if current_speed > 0.0 and current_speed - STOP_ACCELERATION < 0.0:
			current_speed = 0.0
			emit_signal("stopped")
		elif current_speed > 0.0:
			current_speed -= STOP_ACCELERATION
	else:
		current_speed = calculate_speed()
	translation.z -= current_speed * delta
	distance_travelled += current_speed * delta

func calculate_speed():
	var furthest
	for player in get_tree().get_nodes_in_group("player"):
		if !furthest or player.global_transform.origin.z < furthest.z:
			furthest = player.global_transform.origin
	var vp_y = unproject_position(furthest).y
	vp_y = min(vp_y, viewport_height)
	vp_y = max(0, vp_y)
	var ratio = (viewport_height - vp_y) / viewport_height
	return MOVE_SPEED * camera_speed.interpolate(ratio)
