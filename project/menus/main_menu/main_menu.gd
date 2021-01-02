extends TextureRect


var world = preload("res://world/world.tscn")

func _ready():
	$CenterContainer/VBoxContainer/NewAdventure.grab_focus()

func _on_NewAdventure_pressed():
	var _ret = get_tree().change_scene_to(world)

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
