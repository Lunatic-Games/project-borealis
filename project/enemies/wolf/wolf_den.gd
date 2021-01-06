extends StaticBody

const FIRST_SPAWN_TIME = 6.0

var wolf = preload("res://enemies/wolf/wolf.tscn")

# Used when resetting the chunk
func reset():
	$SpawnTimer.stop()
	$FirstSpawnTimer.stop()

# After the first spawn, start the normal spawning
func _on_FirstSpawnTimer_timeout():
	$SpawnTimer.start()
	_on_SpawnTimer_timeout()

# Spawn a wolf at the entrance of the den
func _on_SpawnTimer_timeout():
	var new_wolf = wolf.instance()
	get_parent().get_parent().add_child(new_wolf)
	new_wolf.global_transform.origin = $Position3D.global_transform.origin

# Don't start spawning wolves until the camera sees the den
func _on_VisibilityNotifier_camera_entered(camera):
	if camera != get_viewport().get_camera():
		return
	$FirstSpawnTimer.start(FIRST_SPAWN_TIME)
