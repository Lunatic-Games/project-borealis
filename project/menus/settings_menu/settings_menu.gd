extends CenterContainer


# Back button also leaves settings
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		_on_Back_pressed()
		get_tree().set_input_as_handled()

# Swap fullscreen and window button and enable fullscreen
func _on_Fullscreen_pressed():
	$VBoxContainer/Fullscreen.visible = false
	$VBoxContainer/Windowed.visible = true
	$VBoxContainer/Windowed.grab_focus()
	OS.window_fullscreen = true

# Swap fullscreen and window button and disable fullscreen
func _on_Windowed_pressed():
	$VBoxContainer/Windowed.visible = false
	$VBoxContainer/Fullscreen.visible = true
	$VBoxContainer/Fullscreen.grab_focus()
	OS.window_fullscreen = false

# Leave settings
func _on_Back_pressed():
	visible = false

# Focus correct button when made visible
func _on_visibility_changed():
	if visible:
		if OS.window_fullscreen:
			$VBoxContainer/Fullscreen.visible = false
			$VBoxContainer/Windowed.visible = true
			$VBoxContainer/Windowed.grab_focus()
		else:
			$VBoxContainer/Fullscreen.visible = true
			$VBoxContainer/Windowed.visible = false
			$VBoxContainer/Fullscreen.grab_focus()
