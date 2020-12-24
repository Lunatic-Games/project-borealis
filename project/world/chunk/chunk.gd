extends StaticBody

const ENTITY_CHANCE = 0.01
const SIDE_MARGIN = 3  # Don't spawn entites along edge
const PLAYER_SPACE = 3  # Don't generate an entity within this distance to a player
const ENTITY_SPAWN_CHANCES = {
	"tree": [0.9, preload("res://world/entities/tree/tree.tscn")],
	"rock": [0.1, preload("res://world/entities/rock/rock.tscn")]
}

var rng = RandomNumberGenerator.new()
var unused_entities = {}  # name: array of nodes
var players

onready var entities = $Entities
onready var snow = $Snow
onready var size = $Ground.mesh.size

# Generate entities in the chunk
# Will try to use entities from the past generation if possible
func generate():
	rng.randomize()
	snow.reset_path()
	players = get_tree().get_nodes_in_group("player")
	set_unused_entities()
 
	for x in range(SIDE_MARGIN, size.x - SIDE_MARGIN):
		var x_pos = x - size.x / 2.0
		
		for z in range(0, size.y):
			var z_pos = z - size.y / 2.0
			if (pos_is_near_player(Vector2(x_pos, z_pos)) 
					or rng.randf() >= ENTITY_CHANCE):
				continue
			
			var i = 0.0
			var r = rng.randf()
			for entity_type in ENTITY_SPAWN_CHANCES:
				i += ENTITY_SPAWN_CHANCES[entity_type][0]
				if r < i:
					var entity = unused_entities.get(entity_type, []).pop_front()
					if entity:
						entity.visible = true
						for shape_owner in entity.get_shape_owners():
							entity.shape_owner_set_disabled(shape_owner, false)
					else:
						entity = ENTITY_SPAWN_CHANCES[entity_type][1].instance()
						entity.add_to_group(entity_type + "_entity")
						entities.add_child(entity)
					entity.translation = Vector3(x_pos, 0, z_pos)
					break
	hide_unused_entities()

# Determine if player is within PLAYER_SPACE of a point on the ground
func pos_is_near_player(var pos: Vector2):
	for player in players:
		var player_pos = Vector2(player.translation.x, player.translation.z)
		pos += Vector2(translation.x, translation.z)
		if pos.distance_to(player_pos) < PLAYER_SPACE:
			return true
	return false

# Sort entities into groups that can be used for the next generation
func set_unused_entities():
	unused_entities.clear()
	for entity in entities.get_children():
		for entity_type in ENTITY_SPAWN_CHANCES:
			if entity.is_in_group(entity_type + "_entity"):
				var current = unused_entities.get(entity_type, [])
				current.append(entity)
				unused_entities[entity_type] = current
				break

# Set entities that were not used to invisible and disable collisions
func hide_unused_entities():
	for entity_type in unused_entities:
		for entity in unused_entities[entity_type]:
			entity.visible = false
