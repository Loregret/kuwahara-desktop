// https://www.shadertoy.com/view/XltXD2
shader_type canvas_item;

uniform float pixel_size = 8.0;

void fragment()
{
    vec2 xy = floor((UV / TEXTURE_PIXEL_SIZE).xy/pixel_size + 0.5) * pixel_size;
	vec4 textureColour = texture(TEXTURE, xy / (1.0 / TEXTURE_PIXEL_SIZE).xy);
    COLOR = textureColour;
}