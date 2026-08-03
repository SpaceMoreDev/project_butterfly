shader_type spatial;
render_mode blend_mix, depth_draw_opaque, shadows_disabled;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 scale = vec3(1.0);
uniform float overlay_strength = 0.0;
uniform float speed = 0.5;
uniform float alpha = 0.5;

varying vec3 world_position;
varying vec3 world_normal;
void vertex() {
    world_position = VERTEX;
    world_normal = abs(NORMAL);
}

void fragment() {
	vec3 scaled_pos = world_position * scale;
	vec2 uv_coords;
	
	if (world_normal.x > world_normal.y && world_normal.x > world_normal.z) {
		uv_coords = scaled_pos.zy; 
	}else if (world_normal.y > world_normal.x && world_normal.y > world_normal.z) {
		uv_coords = scaled_pos.xz;
	} 
	else {
		uv_coords = scaled_pos.xy;
	}
	
	vec2 moved_uv = uv_coords;
	moved_uv.x += TIME * speed;
	vec4 tex_color = texture(albedo_texture, uv_coords);
	tex_color = texture(albedo_texture, moved_uv);
	tex_color = mix(tex_color, overlay_color,overlay_strength);
	ALBEDO = tex_color.rgb;
	ALPHA = alpha;
}