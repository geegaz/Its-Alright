shader_type spatial;
render_mode cull_disabled;

uniform vec3 player_pos;

uniform vec4 primary_color : source_color;
uniform vec4 secondary_color : source_color;
uniform sampler2D overlay_tex : source_color, repeat_enable, filter_nearest;
uniform float chaos_amount : hint_range(0.0, 100.0, 0.01) = 10.0;
uniform float chaos_start = 10.0;
uniform float chaos_end = 100.0;
uniform float time_speed = 10.0;

varying float chaos;
varying float floored_time;

float random(float v) {
	return fract(sin(v) * 43758.5453123);
}

float inv_lerp(float a, float b, float v) {
	return (v - a) / (b - a);
}

void vertex() {
	vec3 world_pos = (vec4(VERTEX, 1.0) * MODEL_MATRIX).xyz + NODE_POSITION_WORLD;
	float dist_amount = clamp(inv_lerp(chaos_start, chaos_end, distance(player_pos, world_pos)), 0.0, 1.0);
	chaos = dist_amount * chaos_amount;
	floored_time = floor(TIME * time_speed);
	
	float vertex_floored_time = floor(time_speed * (TIME + world_pos.x + world_pos.y + world_pos.z));
	
	vec3 random_pos = vec3(
		random(UV.x + vertex_floored_time),
		random((UV.x + UV.y) + vertex_floored_time),
		random(UV.y + vertex_floored_time)
	) * 2.0 - 1.0;
	
	VERTEX += random_pos * chaos;
}

void fragment() {
	vec2 offset = vec2(
		random(1.0 + floored_time),
		random(2.0 + floored_time)
	);
	float mask_amount = texture(overlay_tex, SCREEN_UV + offset).r;
	ALBEDO = mix(primary_color.rgb, secondary_color.rgb, mask_amount * chaos);
}
