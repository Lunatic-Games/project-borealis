extends Button


func _ready():
	rect_pivot_offset = rect_size / 2


func _on_focus_entered():
	$AnimationPlayer.play("hover")


func _on_focus_exited():
	$AnimationPlayer.play("unhover")


func _on_button_down():
	$AnimationPlayer.play("press")
