shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx, unshaded;

uniform sampler2D palette_texture : source_color, filter_nearest;

void fragment() {
	// We use the UV coordinates provided by Blockbench to pick a color
	vec4 color = texture(palette_texture, UV);
	ALBEDO = color.rgb;
	
	// Adds a tiny bit of directional darkening based on the surface normal
	float fake_light = dot(NORMAL, vec3(0.5, 1.0, 0.5));
	ALBEDO *= clamp(fake_light + 0.5, 0.4, 1.0);
}