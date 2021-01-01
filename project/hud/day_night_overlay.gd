extends ColorRect

export (Color) var day_color
export (Color) var night_color
export (Curve) var color_ratio
export (NodePath) var day_timer_path

onready var day_timer = get_node(day_timer_path)

# Mixes the day and night color using the ratio curve and the day timer
func _physics_process(_delta):
	var x = (day_timer.wait_time - day_timer.time_left) / day_timer.wait_time
	color = lerp(night_color, day_color, color_ratio.interpolate(x))
