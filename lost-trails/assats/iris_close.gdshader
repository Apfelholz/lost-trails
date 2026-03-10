// Iris-Effekt: eine Ellipse schließt sich von den Rändern zur Mitte hin
shader_type canvas_item;

// Öffnungsradius: 1.0 = vollständig offen, 0.0 = vollständig geschlossen (schwarz)
uniform float iris_radius : hint_range(0.0, 1.5) = 1.1;

// Weichheit der Kante (Anti-Aliasing des Ellipsenrandes)
uniform float softness : hint_range(0.001, 0.2) = 0.04;

// Verhältnis Breite zu Höhe der Ellipse: 1.0 = Kreis, >1.0 = breiter, <1.0 = höher
// Für ein klassisches Filmformat (16:9-Bildschirm) passt z.B. 1.8
uniform float ellipse_ratio : hint_range(0.1, 4.0) = 1.8;

void fragment() {
	// UV auf Mittelpunkt zentrieren, Bereich -0.5 .. 0.5
	vec2 uv = UV - vec2(0.5);

	// Ellipsen-Abstand: x durch ellipse_ratio dividieren streckt die Form horizontal
	float dist = length(vec2(uv.x / ellipse_ratio, uv.y));

	// Alpha = 0 (transparent) innerhalb, 1 (schwarz) außerhalb der Ellipse
	float alpha = smoothstep(iris_radius - softness, iris_radius + softness, dist);
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
