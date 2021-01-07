extends ColorRect


# Check for unpause
func _unhandled_input(event):
	if event.is_action_pressed("pause") and visible:
		_on_Continue_pressed()
		get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_cancel") and !$SettingsMenu.visible:
		_on_Continue_pressed()
		get_tree().set_input_as_handled()

# Pass movement inputs to player so they are up to date when unpaused
func _input(event):
	for player in get_tree().get_nodes_in_group("player"):
		if player.event_is_for_player(event):
			player.check_movement_inputs(event)

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

# Go back to lobby
func _on_Exit_pressed():
	get_tree().paused = false
	get_tree().root.get_node("World").queue_free()
	get_tree().root.get_node("MainMenu/LobbyMenu").return_to()
	Inventory.reset()

# Left settings, make pause menu visible and focused again
func _on_SettingsMenu_visibility_changed():
	if not $SettingsMenu.visible:
		$CenterContainer.visible = true
		$CenterContainer/VBoxContainer/Settings.grab_focus()
