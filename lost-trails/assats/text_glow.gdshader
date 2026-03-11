shader_type canvas_item;

uniform vec4 glow_color: source_color = vec4(0.2, 0.88, 1.0, 1.0);
uniform float glow_size: hint_range(1.0, 25.0) = 7.0;
uniform float glow_intensity: hint_range(0.0, 3.0) = 1.6;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE * glow_size;

	// Sample alpha in a ring around the current pixel
	float glow = 0.0;
	glow += texture(TEXTURE, UV + vec2( px.x,    0.0)).a;
	glow += texture(TEXTURE, UV + vec2(-px.x,    0.0)).a;
	glow += texture(TEXTURE, UV + vec2(  0.0,  px.y)).a;
	glow += texture(TEXTURE, UV + vec2(  0.0, -px.y)).a;
	glow += texture(TEXTURE, UV + vec2( px.x,  px.y)).a * 0.7;
	glow += texture(TEXTURE, UV + vec2(-px.x,  px.y)).a * 0.7;
	glow += texture(TEXTURE, UV + vec2( px.x, -px.y)).a * 0.7;
	glow += texture(TEXTURE, UV + vec2(-px.x, -px.y)).a * 0.7;

	// Second, wider ring for softer falloff
	glow += texture(TEXTURE, UV + vec2( px.x * 2.0,    0.0)).a * 0.4;
	glow += texture(TEXTURE, UV + vec2(-px.x * 2.0,    0.0)).a * 0.4;
	glow += texture(TEXTURE, UV + vec2(   0.0,  px.y * 2.0)).a * 0.4;
	glow += texture(TEXTURE, UV + vec2(   0.0, -px.y * 2.0)).a * 0.4;

	glow = clamp(glow / 7.2, 0.0, 1.0);

	// Subtle slow shimmer
	float shimmer = sin(TIME * 1.8) * 0.07 + 0.93;

	// Composite: glow behind text, original on top
	vec4 glow_col = glow_color * glow * glow_intensity * shimmer;
	COLOR.rgb = mix(glow_col.rgb, original.rgb, original.a);
	COLOR.a = max(original.a, glow_col.a);
}
