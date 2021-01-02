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

# Go to settings menu
func _on_Settings_pressed():
	$CenterContainer.visible = false
	$SettingsMenu.visible = true

# Go to main menu
func _on_ExitToMainMenu_pressed():
	get_tree().paused = false
	var _ret = get_tree().change_scene("res://menus/main_menu/main_menu.tscn")

# Left settings, make pause menu visible and focused again
func _on_SettingsMenu_visibility_changed():
	if not $SettingsMenu.visible:
		$CenterContainer.visible = true
		$CenterContainer/VBoxContainer/Continue.grab_focus()
