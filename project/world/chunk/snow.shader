shader_type spatial;

uniform sampler2D player_path;
uniform ivec2 height_map_size;
uniform int vertex_density;

float height(vec2 position) {
	position.x += float(height_map_size.x) / 2.0;
	position.y += float(height_map_size.y) / 2.0;
	position *= float(vertex_density);
	if (int(position.y) <= 0) {
		position.y = 0.0;
	} else if (int(position.y) >= vertex_density * height_map_size.y - 1) {
		position.y = float(vertex_density * height_map_size.y) - 1.0;
	}
	float val = texelFetch(player_path, ivec2(int(position.x), int(position.y)), 0).r;
	return val * 2.0;
}

void vertex() {
	VERTEX.y = height(VERTEX.xz);
	vec2 e = vec2(0.25, 0.0);
	vec3 normal = normalize(vec3(height(VERTEX.xz - e) - height(VERTEX.xz + e), 2.0 * e.x, height(VERTEX.xz - e.yx) - height(VERTEX.xz + e.yx)));
	NORMAL = normal;
}

