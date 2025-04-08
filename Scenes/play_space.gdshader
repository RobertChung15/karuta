shader_type canvas_item;
uniform float opacity : hint_range(0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Get the UV coordinates
    vec2 uv = UV;

    // Calculate the gradient based on the y-coordinate
    float top_gradient = smoothstep(0.0, 0.2, uv.y);        // Darken the top
    float bottom_gradient = smoothstep(0.8, 1.0, uv.y);     // Darken the bottom

    // Create a middle transparency effect
    float middle_transparency = smoothstep(0.2, 0.8, uv.y);

    // Combine gradients: Darken the top and bottom, and make the middle transparent
    float gradient = max(top_gradient, bottom_gradient) * (1.0 - middle_transparency);

	float alpha = mix(1.0, 0.5, middle_transparency);

    // Get the color from the texture
    vec4 color = texture(TEXTURE, uv);
    color.rgb *= gradient; // Darken the color

	color.a *= 0.7 * opacity;

    COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
