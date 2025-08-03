shader_type spatial;

// Simple 3D shader to create a force-field effect inspired by Faultless Defense from Guilty Gear Xrd.
// Adds scrolling UV and pulsing emission for movement.

render_mode blend_mix, depth_draw_always, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform vec4 emission_color : source_color;
uniform sampler2D texture_albedo : hint_normal;

uniform float emission_amount : hint_range(0.0, 16.0) = 5.0;
uniform float rim_steepness : hint_range(0.0, 16.0) = 3.0;

uniform vec3 uv_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv_offset = vec3(0.0, 0.0, 0.0);

uniform float scroll_speed = 1.0; // Speed of UV movement
uniform float pulse_speed = 2.0;  // Speed of emission pulsing
uniform float pulse_strength = 0.5; // Max added emission from pulse

void vertex() {
	UV = UV * uv_scale.xy + uv_offset.xy + vec2(TIME * scroll_speed, 0.0);
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	// Pulsing emission
	float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5; // range: 0 to 1
	float total_emission = emission_amount + pulse * pulse_strength;
	EMISSION = emission_color.rgb * total_emission;

	// Rim lighting alpha
	float NdotV = dot(NORMAL, VIEW);
	float rim_light = pow(1.0 - NdotV, rim_steepness);
	ALPHA = rim_light * emission_color.a / PI;
}
