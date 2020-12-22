extends Camera

const MOVE_SPEED = 4.0

# Move camera forward every frame
func _physics_process(delta):
	translation.z -= MOVE_SPEED * delta
