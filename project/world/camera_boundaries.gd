extends StaticBody

const REPLACE_DISTANCE = 2.5  # Distance in-front to place player if off camera
const REPLACE_HEIGHT = 1.0  # Distance above ground to player player if off camera

onready var camera = $"../Camera"
onready var close_boundary = $Close

# Update boundaries to match camera
# Also need to check if player is behind due to being stuck behind a static body
# As they can get pushed through the boundary in that case
func _physics_process(_delta):
	translation.z = camera.translation.z
	var close_z = close_boundary.global_transform.origin.z
	for player in get_tree().get_nodes_in_group("player"):
		if player.global_transform.origin.z > close_z:
			player.global_transform.origin.z = close_z - REPLACE_DISTANCE
			player.global_transform.origin.y = REPLACE_HEIGHT
