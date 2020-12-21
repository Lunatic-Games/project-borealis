extends StaticBody

const RESOURCE_DENSITY = 1.0
const RESOURCE_CHANCE = 0.01
const RESOURCE_SPAWN_CHANCES = {
	preload("res://world/resources/rock/rock.tscn"): 0.1,
	preload("res://world/resources/tree/tree.tscn"): 0.9
}
const SIDE_MARGIN = 3
const PLAYER_SPACE = 3
const VARIABLE_POSITION = 0.1

var rng = RandomNumberGenerator.new()
var player

onready var resources = $Resources
onready var snow = $Snow

func generate_resources():
	rng.randomize()
	player = get_tree().get_nodes_in_group("player").front()
	for n in resources.get_children():
		n.queue_free()
	var width = $Ground.mesh.size.x
	var depth = $Ground.mesh.size.y
	var start_x = SIDE_MARGIN * RESOURCE_DENSITY
	var end_x = width / RESOURCE_DENSITY - SIDE_MARGIN * RESOURCE_DENSITY
	for x in range(int(start_x), int(end_x)):
		var x_pos = x * RESOURCE_DENSITY - width / 2.0
		
		
		for z in range(0, int(depth / RESOURCE_DENSITY)):
			var z_pos = z * RESOURCE_DENSITY - depth / 2.0
			if pos_is_near_player(Vector2(x_pos, z_pos)):
				continue
			if rng.randf() >= RESOURCE_CHANCE:
				continue
			
			var i = 0.0
			var r = rng.randf()
			for res in RESOURCE_SPAWN_CHANCES:
				i += RESOURCE_SPAWN_CHANCES[res]
				if r < i:
					var new_res = res.instance()
					resources.add_child(new_res)
					new_res.translation = Vector3(x_pos, 0, z_pos)
					break

func pos_is_near_player(var pos):
	assert(player)
	var player_pos = Vector2(player.translation.x, player.translation.z)
	pos += Vector2(translation.x, translation.z)
	if pos.distance_to(player_pos) < PLAYER_SPACE:
		return true
	return false
