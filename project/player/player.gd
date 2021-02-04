extends KinematicBody

const GRAVITY = 0.3
const MOVE_SPEED = 5.0
const MOVE_ACCELERATION = 0.4
const JUMP_FORCE = 9.0
const TERMINAL_VELOCITY = 10.0

export (String) var device

var velocity = Vector3(0, 0, 0)
var input = Vector2(0, 0)
var movement_inputs = {
	"forward": false,
	"right": false,
	"backward": false,
	"left": false
}

onready var weapon = $Rotation/Weapon

# Handle player input and acceleration
func _physics_process(_delta):
	handle_ground_movement()
	velocity.y = max(velocity.y - GRAVITY, -TERMINAL_VELOCITY)
	velocity = move_and_slide(velocity, Vector3.UP)

# Only handle inputs for associated device
func _input(event):
	if !event_is_for_player(event):
		return
	if event.is_action_pressed("interact"):
		interact()
	if event.is_action_pressed("attack"):
		weapon.attack()
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	check_movement_inputs(event)
	
# Gets horizontal movement inputs and accelerates velocity.xz
func handle_ground_movement():
	input = Vector2(0, 0)
	if movement_inputs["forward"]:
		input.y -= 1
	if movement_inputs["right"]:
		input.x += 1
	if movement_inputs["backward"]:
		input.y += 1
	if movement_inputs["left"]:
		input.x -= 1
	
	if input:
		$Rotation.rotation.y = -input.angle() + PI/2
	
	input = input.normalized()
	if input.y > 0.1:
		velocity.z = lerp(velocity.z, MOVE_SPEED * input.y, MOVE_ACCELERATION)
	elif input.y < -0.1:
		velocity.z = lerp(velocity.z, -MOVE_SPEED * abs(input.y), MOVE_ACCELERATION)
	else:
		velocity.z = lerp(velocity.z, 0.0, MOVE_ACCELERATION)
	if input.x > 0.1:
		velocity.x = lerp(velocity.x, MOVE_SPEED * input.x, MOVE_ACCELERATION)
	elif input.x < -0.1:
		velocity.x = lerp(velocity.x, -MOVE_SPEED * abs(input.x), MOVE_ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, MOVE_ACCELERATION)

# Interact with the closest object in fron that is within the interact area
func interact():
	var closest_body
	var closest_dist = INF
	for body in $Rotation/InteractArea.get_overlapping_bodies():
		if not body.is_in_group("interactable") or not body.has_method("interact"):
			continue
		if global_transform.origin.distance_to(body.global_transform.origin) < closest_dist:
			closest_body = body
	if closest_body:
		closest_body.interact(self)

# Determine if event is for this player's device
func event_is_for_player(event):
	var input_device = str(event.device)
	if event is InputEventKey or event is InputEventMouse:
		input_device = "keyboard"
	if input_device != device:
		return false
	return true

# Keep track of continuous player inputs
func check_movement_inputs(event):
	for direction in ["forward", "right", "backward", "left"]:
		if event.is_action_pressed("move_" + direction):
			movement_inputs[direction] = true
		elif event.is_action_released("move_" + direction):
			movement_inputs[direction] = false
