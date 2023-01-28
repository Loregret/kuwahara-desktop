shader_type canvas_item;

void fragment()
{
    vec4 color = texture(TEXTURE, UV);

    float a = FRAGCOORD.x;
    float r = mod(a, 3.0) / 2.0 * color.r;
    float g = mod(a + 1.0, 3.0) / 2.0 * color.g;
    float b = mod(a + 2.0, 3.0) / 2.0 * color.b;
    COLOR = vec4(r, g, b, 1.0) * 1.5 - 0.1;
}