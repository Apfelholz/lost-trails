shader_type canvas_item;

uniform float hole_size: hint_range(0.1, 0.9) = 0.42;
uniform float edge_softness: hint_range(0.02, 0.5) = 0.2;
uniform vec4 glow_color: source_color = vec4(0.0, 0.85, 1.0, 1.0);
uniform float glow_intensity: hint_range(0.0, 3.0) = 1.2;
uniform float glow_width: hint_range(0.005, 0.2) = 0.04;
uniform float scan_density: hint_range(20.0, 400.0) = 120.0;
uniform float scan_strength: hint_range(0.0, 0.4) = 0.08;

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);

	// Transparent center (the "hole"), dark vignette outside
	float outside = smoothstep(hole_size - edge_softness, hole_size + edge_softness, dist);
	float inside = 1.0 - outside;

	// Glowing ring at the hole boundary
	float ring = exp(-pow((dist - hole_size) / glow_width, 2.0));

	// Subtle pulse on the ring
	float pulse = sin(TIME * 1.5) * 0.15 + 0.85;

	// Horizontal scanlines inside the hole (holo texture)
	float scanline = sin(UV.y * scan_density) * 0.5 + 0.5;
	float scan_alpha = scanline * scan_strength * inside;

	// Compose: black vignette outside + glowing ring edge + scanlines inside
	vec3 col = glow_color.rgb * ring * glow_intensity * pulse;
	float alpha = outside * 0.94 + scan_alpha + ring * glow_intensity * pulse * 0.35;

	COLOR = vec4(col, clamp(alpha, 0.0, 1.0));
}
