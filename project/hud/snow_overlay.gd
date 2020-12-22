extends Node2D


# There is a weird issue with the preprocesing of the particles at the start
# So wait a bit before starting the particles
func _ready():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	for particles in get_children():
		particles.emitting = true
