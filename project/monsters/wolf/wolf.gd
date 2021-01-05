extends KinematicBody

enum States {CHASING, WAITING, ATTACKING, RETREATING}

const MOVE_SPEED = 4.0
const ATTACKING_SPEED = 12.0
const GRAVITY = 0.3
const RETREAT_DISTANCE = 1.5
const RECHASE_DISTANCE = 6.0
const ATTACK_BEGIN_DISTANCE = 5.0
const TOO_CLOSE_DISTANCE = 4.0
const PAST_DIRECTIONS_TO_CONSIDER = 40
const JUMP_FORCE = 6.0

var current_state = States.CHASING
var last_directions = []
var velocity = Vector3(0, 0, 0)

# Perform wolf AI
func _physics_process(_delta):
	var player_origin = get_closest_in_group("player").global_transform.origin
	var player_pos = Vector2(player_origin.x, player_origin.z)
	var pos = Vector2(global_transform.origin.x, global_transform.origin.z)
	rotation = Vector3(0, -pos.angle_to_point(player_pos) + PI, 0)
	var movement = pos.direction_to(player_pos)
	
	if current_state == States.ATTACKING:
		if pos.distance_to(player_pos) < RETREAT_DISTANCE:
			current_state = States.RETREATING
		movement *= ATTACKING_SPEED
	elif current_state == States.RETREATING:
		if pos.distance_to(player_pos) > RECHASE_DISTANCE:
			current_state = States.WAITING
		movement *= -MOVE_SPEED
	elif current_state == States.CHASING:
		if pos.distance_to(player_pos) < ATTACK_BEGIN_DISTANCE:
			current_state = States.WAITING
			if $AttackTimer.is_stopped():
				$AttackTimer.start()
		movement *= MOVE_SPEED
	elif current_state == States.WAITING:
		movement = Vector2(0, 0)
		if pos.distance_to(player_pos) > RECHASE_DISTANCE:
			current_state = States.CHASING
		elif pos.distance_to(player_pos) < TOO_CLOSE_DISTANCE:
			current_state = States.RETREATING

	var other_wolf = get_closest_in_group("wolf")
	if other_wolf:
		movement = keep_spread_out(other_wolf, pos, player_pos, movement)
	
	velocity.y -= GRAVITY
	velocity = move_and_slide(Vector3(movement.x, velocity.y, movement.y),
		Vector3.UP)

# Get the nearest node in a group to this wolf
func get_closest_in_group(group):
	var objs = get_tree().get_nodes_in_group(group)
	objs.sort_custom(self, "_distance_sort")
	for obj in objs:
		if obj != self:
			return obj
	return null

# Used for sort_custom
func _distance_sort(a, b):
	var a_dist = global_transform.origin.distance_to(a.global_transform.origin)
	var b_dist = global_transform.origin.distance_to(b.global_transform.origin)
	return a_dist < b_dist

# Wolves will circle around the player and will try not to be too close togther
func keep_spread_out(other_wolf, pos, player_pos, movement):
	var other_wolf_origin = other_wolf.global_transform.origin
	var other_wolf_pos = Vector2(other_wolf_origin.x, other_wolf_origin.z)
	if pos.distance_to(other_wolf_pos) < 20.0 or current_state == States.WAITING:
		var angle_between = pos.direction_to(player_pos).angle_to(other_wolf_pos.direction_to(player_pos))
		if angle_between < 0.0:
			last_directions.append(Vector2.LEFT)
		else:
			last_directions.append(Vector2.RIGHT)
		while len(last_directions) > PAST_DIRECTIONS_TO_CONSIDER:
			last_directions.pop_front()
		if last_directions.count(Vector2.RIGHT)/len(last_directions) > 0.5:
			movement -= pos.direction_to(player_pos).tangent() * MOVE_SPEED
		else:
			movement += pos.direction_to(player_pos).tangent() * MOVE_SPEED
	return movement

# Perform attack
func _on_AttackTimer_timeout():
	current_state = States.ATTACKING
	velocity.y = JUMP_FORCE
