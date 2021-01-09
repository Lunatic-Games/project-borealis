extends CenterContainer


# Back button also leaves settings
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		_on_Back_pressed()
		get_tree().set_input_as_handled()

# Swap fullscreen and window button and enable fullscreen
func _on_Fullscreen_pressed():
	$Buttons/Fullscreen.visible = false
	$Buttons/Windowed.visible = true
	$Buttons/Windowed.grab_focus()
	OS.window_fullscreen = true

# Swap fullscreen and window button and disable fullscreen
func _on_Windowed_pressed():
	$Buttons/Windowed.visible = false
	$Buttons/Fullscreen.visible = true
	$Buttons/Fullscreen.grab_focus()
	OS.window_fullscreen = false

# Leave settings
func _on_Back_pressed():
	visible = false

# Focus correct button when made visible and play transition animation
func _on_visibility_changed():
	if visible:
		$AnimationPlayer.play("fast_buttons")
		if OS.window_fullscreen:
			$Buttons/Fullscreen.visible = false
			$Buttons/Windowed.visible = true
			$Buttons/Windowed.grab_focus()
		else:
			$Buttons/Fullscreen.visible = true
			$Buttons/Windowed.visible = false
			$Buttons/Fullscreen.grab_focus()
