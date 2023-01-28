// https://www.shadertoy.com/view/XlycDV
shader_type canvas_item;

uniform float OFFSET_STRENGTH = 0.8;
uniform float SHARPENING_AMOUNT = 7.0;

void fragment( )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = UV;

    // Time varying pixel color
    vec3 col = texture(TEXTURE, uv).rgb;
    
    float offsetStrength = .5;
    float effectStrength = 12.0;
    
    vec3 blur = col;
    blur += texture(TEXTURE, uv + vec2(0.0, 0.001 * OFFSET_STRENGTH)).rgb;
    blur += texture(TEXTURE, uv + vec2(0.001 * OFFSET_STRENGTH, 0.0)).rgb;
    blur += texture(TEXTURE, uv - vec2(0.0, 0.001 * OFFSET_STRENGTH)).rgb;
    blur += texture(TEXTURE, uv - vec2(0.001 * OFFSET_STRENGTH, 0.0)).rgb;
    
    blur += texture(TEXTURE, uv + vec2(0.001 * OFFSET_STRENGTH)).rgb / 2.0;
    blur += texture(TEXTURE, uv - vec2(0.001 * OFFSET_STRENGTH)).rgb / 2.0;
    blur += texture(TEXTURE, uv + vec2(0.001 * OFFSET_STRENGTH, -0.001 * OFFSET_STRENGTH)).rgb / 2.0;
    blur += texture(TEXTURE, uv + vec2(-0.001 * OFFSET_STRENGTH, 0.001 * OFFSET_STRENGTH)).rgb / 2.0;
    
    blur /= 7.0;
    
    float sharpness = (col - blur).r * SHARPENING_AMOUNT;
    
    col += sharpness;

    
    COLOR = vec4(col, 1.0);
}