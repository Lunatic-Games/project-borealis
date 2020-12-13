extends MeshInstance

const MESH_SIZE = Vector2(40, 60)  # Should be integers
const VERTEX_DENSITY = 4 # Should be integer
const DEFAULT_HEIGHT = 0.5
const PATH_HEIGHT = 0.25

var st = SurfaceTool.new() 
var height_map_texture = ImageTexture.new()
var height_map = Image.new()

func _ready():
	height_map.create(MESH_SIZE.x * VERTEX_DENSITY, 
		MESH_SIZE.y * VERTEX_DENSITY, false, Image.FORMAT_RGB8)
	height_map.fill(get_height_color(DEFAULT_HEIGHT))
	height_map_texture.create_from_image(height_map)
	create_mesh()
	material_override.set("shader_param/player_path", height_map_texture)

func _physics_process(_delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	if !player:
		return
	
	if player.is_on_floor():
		var chunk_position = get_parent().transform.origin
		make_player_path(Vector2(player.transform.origin.x, player.transform.origin.z) - Vector2(chunk_position.x, chunk_position.z))

func create_mesh():
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var v_length = 1.0 / float(VERTEX_DENSITY)
	for x in range(MESH_SIZE.x * VERTEX_DENSITY):
		for z in range(MESH_SIZE.y * VERTEX_DENSITY):
			var x_pos = float(x) / float(VERTEX_DENSITY) - MESH_SIZE.x / 2.0
			var z_pos = float(z) / float(VERTEX_DENSITY) - MESH_SIZE.y / 2.0
			# Left triangle
			add_mesh_point(x_pos, z_pos)
			add_mesh_point(x_pos + v_length / 2.0, z_pos + v_length / 2.0)
			add_mesh_point(x_pos, z_pos + v_length)
			# Top triangle
			add_mesh_point(x_pos, z_pos)
			add_mesh_point(x_pos + v_length, z_pos)
			add_mesh_point(x_pos + v_length / 2.0, z_pos + v_length / 2.0)
			# Right triangle
			add_mesh_point(x_pos + v_length, z_pos)
			add_mesh_point(x_pos + v_length, z_pos + v_length)
			add_mesh_point(x_pos + v_length / 2.0, z_pos + v_length / 2.0)
			# Bottom triangle
			add_mesh_point(x_pos + v_length, z_pos + v_length)
			add_mesh_point(x_pos, z_pos + v_length)
			add_mesh_point(x_pos + v_length / 2.0, z_pos + v_length / 2.0)
			
	st.index()
	mesh = st.commit()

func make_player_path(position):
	height_map.lock()
	set_height(position, PATH_HEIGHT)
	set_height(position, PATH_HEIGHT, Vector2(1, 0))
	set_height(position, PATH_HEIGHT, Vector2(0, 1))
	set_height(position, PATH_HEIGHT, Vector2(0, -1))
	set_height(position, PATH_HEIGHT, Vector2(1, 1))
	set_height(position, PATH_HEIGHT, Vector2(1, -1))
	height_map.unlock()
	height_map_texture.create_from_image(height_map)

func add_mesh_point(x, z):
	st.add_vertex(Vector3(x, DEFAULT_HEIGHT, z))

func get_height_color(height):
	return Color(height, height, height)

func set_height(world_pos, height, offset=Vector2(0, 0), _min_of_two=true):
	var image_coord = (world_pos + MESH_SIZE / 2.0) * float(VERTEX_DENSITY)
	image_coord += offset
	if image_coord.x < 0.0 or image_coord.y < 0.0:
		return
	if image_coord.x > MESH_SIZE.x * VERTEX_DENSITY:
		return
	if image_coord.y > MESH_SIZE.y * VERTEX_DENSITY:
		return
	if height_map.get_pixelv(image_coord).r < height:
		return
	height_map.set_pixelv(image_coord, get_height_color(height))
