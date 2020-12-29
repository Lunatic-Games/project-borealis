extends KinematicBody

const GRAVITY = 0.3
const MOVE_SPEED = 5.0
const MOVE_ACCELERATION = 0.4
const JUMP_FORCE = 9.0
const TERMINAL_VELOCITY = 10.0

var velocity = Vector3(0, 0, 0)
var input = Vector2(0, 0)
var inventory = preload("res://player/inventory.gd").new()

# Handle player input and acceleration
func _physics_process(_delta):
	handle_ground_movement()
	handle_vertical_movement()
	velocity = move_and_slide(velocity, Vector3.UP)

func _input(event):
	if event.is_action_pressed("interact"):
		interact()
		
# Gets horizontal movement inputs and accelerates velocity.xz
func handle_ground_movement():
	input = Vector2(0, 0)
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
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

# Get jump input and applies gravity to velocity.y
func handle_vertical_movement():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	velocity.y = max(velocity.y - GRAVITY, -TERMINAL_VELOCITY)

# Interact with the closest object in fron that is within the interact area
func interact():
	var closest_body
	var closest_dist = INF
	for body in $Rotation/Area.get_overlapping_bodies():
		if not body.is_in_group("interactable") or not body.has_method("interact"):
			continue
		if global_transform.origin.distance_to(body.global_transform.origin) < closest_dist:
			closest_body = body
	if closest_body:
		closest_body.interact(self)
