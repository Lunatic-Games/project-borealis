shader_type spatial;

uniform vec4 color: hint_color;

void fragment() {
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
	ALBEDO = color.rgb;
}