extends KinematicBody

const MOVE_SPEED = 4.0
const ATTACKING_SPEED = 12.0
const GRAVITY = 1.0

var on_player = false
var attacking = false
var retreating = false

func _physics_process(_delta):
	var player_origin = get_closest_player().global_transform.origin
	var player_pos = Vector2(player_origin.x, player_origin.z)
	var pos = Vector2(global_transform.origin.x, global_transform.origin.z)
	rotation = Vector3(0, -pos.angle_to_point(player_pos) + PI, 0)
	var movement = pos.direction_to(player_pos)
	
	if pos.distance_to(player_pos) < 1.0 and attacking:
		attacking = false
	if pos.distance_to(player_pos) < 4.0:
		retreating = true
	if pos.distance_to(player_pos) < 5.0:
		if not on_player:
			$AttackTimer.start()
		on_player = true
	elif pos.distance_to(player_pos) > 6.0:
		on_player = false
		retreating = false
	
	if attacking:
		movement *= ATTACKING_SPEED
	elif retreating:
		movement *= -MOVE_SPEED
	elif on_player:
		movement = Vector2(0, 0)
		var other_wolf = get_closest_other_wolf()
		if other_wolf:
			var other_wolf_origin = other_wolf.global_transform.origin
			var other_wolf_pos = Vector2(other_wolf_origin.x, other_wolf_origin.z)
			var angle_between = pos.direction_to(player_pos).angle_to(other_wolf_pos.direction_to(player_pos))
			if angle_between < 0.0 and angle_between > -PI + 0.1:
				movement += pos.direction_to(player_pos).tangent() * MOVE_SPEED
			elif angle_between > 0.0 and angle_between < PI - 0.1:
				movement -= pos.direction_to(player_pos).tangent() * MOVE_SPEED
	else:
		movement *= MOVE_SPEED
	var _velocity = move_and_slide(Vector3(movement.x, -GRAVITY, movement.y),
		Vector3.UP)

func get_closest_player():
	var closest_distance = INF
	var closest = null
	for player in get_tree().get_nodes_in_group("player"):
		var d = global_transform.origin.distance_to(player.global_transform.origin)
		if d < closest_distance:
			closest_distance = d
			closest = player
	assert(closest)
	return closest

func get_closest_other_wolf():
	var closest_distance = INF
	var closest = null
	for wolf in get_tree().get_nodes_in_group("wolf"):
		if wolf == self:
			continue
		var d = global_transform.origin.distance_to(wolf.global_transform.origin)
		if d < closest_distance:
			closest_distance = d
			closest = wolf
	return closest

func _on_AttackTimer_timeout():
	attacking = true
