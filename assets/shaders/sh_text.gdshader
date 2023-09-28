shader_type canvas_item;

uniform float time_speed = 10.0;
uniform float vertex_offset_multiplier : hint_range(0.0, 10.0, 0.1) = 5.0;
uniform float uv_offset_multiplier : hint_range(0.0, 1.0, 0.1) = 0.05;

varying float floored_time;

float random(float v) {
	return fract(sin(v) * 43758.5453123);
}

void vertex() {
	floored_time = floor(TIME * time_speed);
	
	float vertex_floored_time = floor((TIME + VERTEX.x + VERTEX.y) * time_speed);
	vec2 offset = vec2(
		random(UV.x + vertex_floored_time * 3.65),
		random(UV.y + vertex_floored_time * -4.78)
	) * 2.0 - 1.0;
	
	VERTEX += offset * vertex_offset_multiplier;
}

void fragment() {
	vec4 col = COLOR;
	vec2 offset = vec2(
		random(floored_time * 0.72),
		random(floored_time * -0.92)
	) * 2.0 - 1.0;
	
	offset *= random(floored_time * 9.86) * uv_offset_multiplier;
	
	COLOR = col * texture(TEXTURE, UV + offset);
}
