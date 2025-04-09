shader_type canvas_item;

uniform vec4 glow_color;
uniform float glow_strength;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 glow = tex_color * glow_color * glow_strength;

    COLOR = tex_color + glow;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
