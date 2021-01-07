extends Control

onready var player_1_container = $HBoxContainer/CharacterContainer1
onready var player_2_container = $HBoxContainer/CharacterContainer2

func _ready():
	_on_visibility_changed()

func _input(event):
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey 
			and event.is_action_pressed("pause")):
		_on_BackButton_pressed()
		return
	
	var event_device = str(event.device)
	if event is InputEventKey or event is InputEventMouseButton:
		event_device = "keyboard"
	elif not event is InputEventJoypadButton:
		return
	if "pressed" in event and not event.pressed:
		return
	if event is InputEventMouseButton and $BackButton.is_hovered():
		return
	
	if player_1_container.device == null and (
			player_1_container.device != event_device and
			player_2_container.device != event_device):
		player_1_container.set_device(event_device)
		get_tree().set_input_as_handled()
	elif player_2_container.device == null and (
			player_1_container.device != event_device and
			player_2_container.device != event_device):
		player_2_container.set_device(event_device)
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
	player_1_container.disconnect_device()
	player_2_container.disconnect_device()

func _on_ReadyButton_pressed():
	if !player_1_container.device:
		return
	player_1_container.set_ready(true)
	if player_2_container.device:
		player_2_container.set_ready(true)

func _on_character_container_ready_changed(is_ready):
	if not is_ready:
		if $CountdownOverlay.visible:
			$CountdownOverlay.stop()
		return
	
	var ready = 0
	var n = 0
	if player_1_container.ready:
		ready += 1
	if player_2_container.ready:
		ready += 1
	if player_1_container.device:
		n += 1
	if player_2_container.device:
		n += 1
	if n == ready:
		$CountdownOverlay.start()

func return_to():
	get_parent().visible = true
	$CountdownOverlay.stop()
	if player_1_container.device:
		player_1_container.set_ready(false)
	if player_2_container.device:
		player_2_container.set_ready(false)
