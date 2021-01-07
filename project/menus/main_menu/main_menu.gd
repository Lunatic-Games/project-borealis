extends TextureRect


var world = preload("res://world/world.tscn")

func _ready():
	$CenterContainer/VBoxContainer/NewAdventure.grab_focus()

func _on_NewAdventure_pressed():
	$MarginContainer.visible = false
	$CenterContainer.visible = false
	$LobbyMenu.visible = true

func _on_Settings_pressed():
	$MarginContainer.visible = false
	$CenterContainer.visible = false
	$SettingsMenu.visible = true

func _on_ExitToDesktop_pressed():
	get_tree().quit()

func _on_SettingsMenu_visibility_changed():
	if not $SettingsMenu.visible:
		$MarginContainer.visible = true
		$CenterContainer.visible = true
		$CenterContainer/VBoxContainer/Settings.grab_focus()

func _on_LobbyMenu_visibility_changed():
	if not $LobbyMenu.visible:
		$MarginContainer.visible = true
		$CenterContainer.visible = true
		$CenterContainer/VBoxContainer/NewAdventure.grab_focus()
