extends MeshInstance

const MESH_SIZE = Vector2(40, 60)  # Should be integers
const VERTEX_DENSITY = 4 # Should be integer
const DEFAULT_HEIGHT = 0.5
const PATH_HEIGHT = 0.25

var surface_tool = SurfaceTool.new() 
var height_map_texture = ImageTexture.new()
var height_map = Image.new()

# Create mesh and height map
func _ready():
	height_map.create(MESH_SIZE.x * VERTEX_DENSITY, 
		MESH_SIZE.y * VERTEX_DENSITY, false, Image.FORMAT_RGB8)
	height_map.fill(get_height_color(DEFAULT_HEIGHT))
	height_map_texture.create_from_image(height_map)
	create_mesh()
	material_override.set("shader_param/player_path", height_map_texture)

# Update player paths based on current positions
func _physics_process(_delta):
	for player in get_tree().get_nodes_in_group("player"):
		if player.is_on_floor():
			var path_pos = player.transform.origin - get_parent().transform.origin
			make_player_path(Vector2(path_pos.x, path_pos.z))

# Create the mesh using SurfaceTool
# Uses 4 triangles to make up a square instead of 2 to help with diagonal edges
func create_mesh():
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
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
			
	surface_tool.index()
	mesh = surface_tool.commit()

# Set the surrounding area to be a lower height
func make_player_path(position: Vector2):
	height_map.lock()
	set_height(position, PATH_HEIGHT)
	set_height(position, PATH_HEIGHT, Vector2(1, 0))
	set_height(position, PATH_HEIGHT, Vector2(0, 1))
	set_height(position, PATH_HEIGHT, Vector2(0, -1))
	set_height(position, PATH_HEIGHT, Vector2(1, 1))
	set_height(position, PATH_HEIGHT, Vector2(1, -1))
	height_map.unlock()
	height_map_texture.create_from_image(height_map)

# Add a vertex to the SurfaceTool
func add_mesh_point(x, z):
	surface_tool.add_vertex(Vector3(x, DEFAULT_HEIGHT, z))

# Returns a greyscale color representing the height between 0.0 and 1.0
func get_height_color(height):
	return Color(height, height, height)

# Set the value of the height map at a given position + offset
# If min_of_two is true, it will only set if current height is higher
func set_height(world_pos, height, offset=Vector2(0, 0), min_of_two=true):
	var image_coord = (world_pos + MESH_SIZE / 2.0) * float(VERTEX_DENSITY)
	image_coord += offset
	if image_coord.x < 0.0 or image_coord.y < 0.0:
		return
	if image_coord.x > MESH_SIZE.x * VERTEX_DENSITY:
		return
	if image_coord.y > MESH_SIZE.y * VERTEX_DENSITY:
		return
	if min_of_two and height_map.get_pixelv(image_coord).r < height:
		return
	height_map.set_pixelv(image_coord, get_height_color(height))

# Clear the height map
func reset_path():
	height_map.fill(get_height_color(DEFAULT_HEIGHT))
	height_map_texture.create_from_image(height_map)
