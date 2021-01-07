extends Control

signal ready_changed

const SCROLL_TIME = 0.3

var character_view = preload("res://menus/lobby_menu/character_view.tscn")
var characters = ["Adventurer", "Second", "Third"]
var view_i = 0
var ready = false
var device

onready var scroll = $ScrollContainer
onready var hbox = $ScrollContainer/HBoxContainer
onready var tween = $ScrollContainer/Tween
onready var view_size = $ScrollContainer/HBoxContainer/CharacterView.rect_min_size

func _ready():
	$ScrollContainer/HBoxContainer/CharacterView.queue_free()
	for character in characters:
		var new_view = character_view.instance()
		hbox.add_child(new_view)
		new_view.label.text = character

func _input(event):
	var event_device = str(event.device)
	if event is InputEventKey or event is InputEventMouseButton:
		event_device = "keyboard"
	if not device or device != event_device:
		return
	
	if event.is_action_pressed("ui_right") and _can_scroll():
		_scroll_right()
	if event.is_action_pressed("ui_left") and _can_scroll():
		_scroll_left()
	if event.is_action_pressed("ui_accept") and not ready:
		set_ready(true)
	if (event.is_action_pressed("ui_cancel") or 
			(event is InputEventKey and event.is_action_pressed("pause"))):
		if ready:
			set_ready(false)
		else:
			disconnect_device()
		get_tree().set_input_as_handled()

func _can_scroll():
	if characters.size() < 2 or tween.is_active() or ready or $ReadyOverlay.visible:
		return false
	return true

func _scroll_right():
	if view_i == characters.size() - 1:
		var n = hbox.get_child(view_i)
		hbox.move_child(n, 0)
		scroll.scroll_horizontal = 0
		view_i = 0
		tween.connect("tween_all_completed", hbox, "move_child",
			[n, characters.size() - 1], CONNECT_ONESHOT)
		tween.connect("tween_all_completed", scroll, "set_h_scroll",
			[0], CONNECT_ONESHOT)
	else:
		view_i += 1
	tween.interpolate_property(scroll, "scroll_horizontal",
		scroll.scroll_horizontal, scroll.scroll_horizontal + view_size.x,
		SCROLL_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func _scroll_left():
	if view_i == 0:
		var n = hbox.get_child(0)
		hbox.move_child(n, characters.size() - 1)
		scroll.scroll_horizontal = view_size.x * (characters.size() - 1)
		view_i = characters.size() - 1
		tween.connect("tween_all_completed", hbox, "move_child",
			[n, 0], CONNECT_ONESHOT)
		tween.connect("tween_all_completed", scroll, "set_h_scroll",
			[view_size.x * (characters.size() - 1)], CONNECT_ONESHOT)
	else:
		view_i -= 1
	tween.interpolate_property(scroll, "scroll_horizontal",
		scroll.scroll_horizontal, scroll.scroll_horizontal - view_size.x,
		SCROLL_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func set_ready(is_ready):
	if is_ready:
		$ReadyOverlay.visible = true
		$LeftButton.visible = false
		$RightButton.visible = false
		$DisconnectReadyContainer.visible = false
		if device == "keyboard":
			$UnreadyButton.visible = true
		ready = true
	else:
		$ReadyOverlay.visible = false
		$LeftButton.visible = true
		$RightButton.visible = true
		$UnreadyButton.visible = false
		if device == "keyboard":
			$DisconnectReadyContainer.visible = true
		ready = false
	emit_signal("ready_changed", is_ready)

func set_device(new_device):
	device = new_device
	$WaitingForPressOverlay.visible = false
	$LeftButton.visible = true
	$RightButton.visible = true
	$ScrollContainer.visible = true
	if device == "keyboard":
		$DisconnectReadyContainer.visible = true

func disconnect_device():
	set_ready(false)
	self.device = null
	$WaitingForPressOverlay.visible = true
	$LeftButton.visible = false
	$RightButton.visible = false
	$DisconnectReadyContainer.visible = false
	$ScrollContainer.visible = false
	if tween.is_active():
		yield(tween, "tween_all_completed")
	view_i = 0
	scroll.scroll_horizontal = 0

func _on_LeftButton_pressed():
	if device != "keyboard":
		return
	if _can_scroll():
		_scroll_left()

func _on_RightButton_pressed():
	if device != "keyboard":
		return
	if _can_scroll():
		_scroll_right()

func _on_DisconnectButton_pressed():
	disconnect_device()

func _on_ReadyButton_pressed():
	set_ready(true)

func _on_UnreadyButton_pressed():
	set_ready(false)
