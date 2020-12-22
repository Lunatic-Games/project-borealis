extends Camera

const MOVE_SPEED = 6.0

export (Curve) var camera_speed  # Scales camera speed based on player depth
onready var viewport_height = get_viewport().size.y

# Move camera forward every frame, scales with player depth
func _physics_process(delta):
	var furthest
	for player in get_tree().get_nodes_in_group("player"):
		if !furthest or player.global_transform.origin.z < furthest.z:
			furthest = player.global_transform.origin
	var vp_y = unproject_position(furthest).y
	vp_y = min(vp_y, viewport_height)
	vp_y = max(0, vp_y)
	var depth_mod = camera_speed.interpolate((720 - vp_y) / viewport_height)
	translation.z -= MOVE_SPEED * delta * depth_mod
	
