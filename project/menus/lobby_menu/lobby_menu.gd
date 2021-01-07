extends Control

onready var player_1_container = $CenterContainer/HBoxContainer/CharacterContainer1
onready var player_2_container = $CenterContainer/HBoxContainer/CharacterContainer2

func _ready():
	_on_visibility_changed()

func _input(event):
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey 
			and event.scancode == KEY_ESCAPE):
		if not player_1_container.ready and not player_2_container.ready:
			_on_BackButton_pressed()
			
	var event_device
	if event is InputEventKey or event is InputEventMouseButton:
		event_device = "keyboard"
	if (player_1_container.device != event_device and 
			player_2_container.device != event_device):
		player_1_container.set_device(event_device)
		get_tree().set_input_as_handled()

func _on_visibility_changed():
	if visible:
		set_process_input(true)
		player_1_container.set_process_input(true)
		player_2_container.set_process_input(true)
	else:
		set_process_input(false)
		player_1_container.set_process_input(false)
		player_2_container.set_process_input(false)

func _on_BackButton_pressed():
	visible = false


func _on_ReadyButton_pressed():
	if !player_1_container.device:
		return
	player_1_container.set_ready(true)
	if player_2_container.device:
		player_2_container.set_ready(true)
