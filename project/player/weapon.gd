extends Spatial

export (NodePath) var player_path
export (float) var damage
export (float) var knockback_strength

onready var player = get_node(player_path)

func attack():
	var player_pos = player.global_transform.origin
	for body in $HitArea.get_overlapping_bodies():
		if not body.is_in_group("enemy") or not body.has_method("hit"):
			continue
		var body_pos = body.global_transform.origin
		var knockback = (body_pos - player_pos).normalized() * knockback_strength
		body.hit(damage, knockback)
