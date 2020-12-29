extends ColorRect


# Check for unpause
func _unhandled_input(event):
	if event.is_action_pressed("pause") and visible:
		_on_Continue_pressed()
		get_tree().set_input_as_handled()

# Set continue to be focused on being visible
func _on_visibility_changed():
	if visible:
		$CenterContainer/VBoxContainer/Continue.grab_focus()

# Resume gameplay
func _on_Continue_pressed():
	get_tree().paused = false
	visible = false

# Quit
func _on_ExitToMainMenu_pressed():
	get_tree().quit()
