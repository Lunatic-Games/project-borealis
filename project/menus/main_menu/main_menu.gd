extends TextureRect

# Set default focus
func _ready():
	$CenterContainer/Buttons/NewAdventure.grab_focus()

# Transition to lobby
func _on_NewAdventure_pressed():
	$MarginContainer.visible = false
	$CenterContainer.visible = false
	$LobbyMenu.visible = true

# Transition to settings
func _on_Settings_pressed():
	$MarginContainer.visible = false
	$CenterContainer.visible = false
	$SettingsMenu.visible = true

# Exit game
func _on_ExitToDesktop_pressed():
	get_tree().quit()

# Set main menu to visible again after returning from settings
func _on_SettingsMenu_visibility_changed():
	if not $SettingsMenu.visible:
		$AnimationPlayer.play("fast_buttons")
		$MarginContainer.visible = true
		$CenterContainer.visible = true
		$CenterContainer/Buttons/Settings.grab_focus()

# Set main menu to visible again after returning from lobby
func _on_LobbyMenu_visibility_changed():
	if not $LobbyMenu.visible:
		$AnimationPlayer.play("fast_buttons")
		$MarginContainer.visible = true
		$CenterContainer.visible = true
		$CenterContainer/Buttons/NewAdventure.grab_focus()
