extends StaticBody

const ENTITY_CHANCE = 0.01

const ENTITY_SPAWN_CHANCES = {  # Should add up to 1.0
	preload("res://world/entities/rock/rock.tscn"): 0.1,
	preload("res://world/entities/tree/tree.tscn"): 0.9
}
const SIDE_MARGIN = 3  # Don't spawn entites along edge
const PLAYER_SPACE = 3  # Don't generate an entity within this distance to a player

var rng = RandomNumberGenerator.new()
var players

onready var entities = $Entities
onready var snow = $Snow
onready var size = $Ground.mesh.size

# Generate 
func generate():
	rng.randomize()
	snow.reset_path()
	players = get_tree().get_nodes_in_group("player")
	for n in entities.get_children():
		n.queue_free()
 
	for x in range(SIDE_MARGIN, size.x - SIDE_MARGIN):
		var x_pos = x - size.x / 2.0
		
		for z in range(0, size.y):
			var z_pos = z - size.y / 2.0
			if (pos_is_near_player(Vector2(x_pos, z_pos)) 
					or rng.randf() >= ENTITY_CHANCE):
				continue
			
			var i = 0.0
			var r = rng.randf()
			for res in ENTITY_SPAWN_CHANCES:
				i += ENTITY_SPAWN_CHANCES[res]
				if r < i:
					var new_res = res.instance()
					entities.add_child(new_res)
					new_res.translation = Vector3(x_pos, 0, z_pos)
					break

# Determine if player is within PLAYER_SPACE of a point on the ground
func pos_is_near_player(var pos: Vector2):
	for player in players:
		var player_pos = Vector2(player.translation.x, player.translation.z)
		pos += Vector2(translation.x, translation.z)
		if pos.distance_to(player_pos) < PLAYER_SPACE:
			return true
	return false
