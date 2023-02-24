shader_type canvas_item;

const mat4 M = mat4(
    vec4(0., 8., 2., 10.),
    vec4(12., 4., 14., 6.),
    vec4(3., 11., 1., 9.),
    vec4(15., 7., 13., 5.)
    );

uniform float R = 0.25;

uniform float pixel_size = 2.;

uniform float brightness = 1.;

void dithering(inout float v, vec2 coords)
{
    v += R * (M[int(coords.x) % 4][int(coords.y) % 4] / 16.0 - .5);
    v = (step(.25, v) + step(.5, v) + step(.75, v)) / 3.;
}


void fragment( )
{
    vec2 fragCoord = FRAGCOORD.xy - mod(FRAGCOORD.xy, pixel_size) - vec2(pixel_size, pixel_size) * .5;
    vec2 uv = UV;
    
    vec3 col = texture(TEXTURE, uv).rgb;
    col *= brightness;
    
    float v = col.r * .299 + col.g * .587 + col.b * .114;

    
    dithering(v, fragCoord);
    dithering(col.r, fragCoord);
    dithering(col.g, fragCoord);
    dithering(col.b, fragCoord);
    
    COLOR = vec4(col, 1.0);
}