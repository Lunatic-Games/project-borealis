extends StaticBody


var wolf = preload("res://monsters/wolf/wolf.tscn")

func _on_SpawnTimer_timeout():
	var new_wolf = wolf.instance()
	get_parent().get_parent().add_child(new_wolf)
	new_wolf.global_transform.origin = $Position3D.global_transform.origin


func _on_FirstSpawnTimer_timeout():
	$SpawnTimer.start()
