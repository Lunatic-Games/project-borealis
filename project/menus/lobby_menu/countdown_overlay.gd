extends ColorRect

export (NodePath) var p1_container_path
export (NodePath) var p2_container_path

var world = preload("res://world/world.tscn")

func _process(_delta):
	$Label.text = str(ceil($CountdownTimer.time_left))
	
func start():
	$CountdownTimer.start()
	$Label.text = str(ceil($CountdownTimer.time_left))
	visible = true

func stop():
	visible = false
	$CountdownTimer.stop()

func _on_CountdownTimer_timeout():
	get_tree().root.get_node("MainMenu").visible = false
	var new_world = world.instance()
	new_world.set_players(get_node(p1_container_path).device,
		get_node(p2_container_path).device)
	get_tree().root.add_child(new_world)
