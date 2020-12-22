extends Camera

const MOVE_SPEED = 4.0

export (Curve) var camera_speed  # Scales camera speed based on player depth
onready var viewport_height = get_viewport().size.y

# Move camera forward every frame
func _physics_process(delta):
	var furthest = Vector3(0, 0, 0)
	for player in get_tree().get_nodes_in_group("player"):
		if player.transform.origin.z < furthest.z:
			furthest = player.transform.origin
	var vp_y = unproject_position(furthest).y
	vp_y = min(vp_y, viewport_height)
	vp_y = max(0, vp_y)
	var depth_mod = camera_speed.interpolate((720 - vp_y) / viewport_height)
	translation.z -= MOVE_SPEED * delta * depth_mod
	
