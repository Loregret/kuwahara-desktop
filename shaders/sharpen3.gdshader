// https://www.shadertoy.com/view/wtlSWB
shader_type canvas_item;

uniform float sharp_strength : hint_range(0, 1) = 0.2;

vec3 srgb2lin(vec3 color)
{
	return color * color;    
}

vec3 lin2srgb(vec3 color)
{
 	return sqrt(color);  
//	ivec2 s = ivec2()
}

// Contrast Adaptive Sharpening (CAS)
// Reference: Lou Kramer, FidelityFX CAS, AMD Developer Day 2019,
// https://gpuopen.com/wp-content/uploads/2019/07/FidelityFX-CAS.pptx
vec3 cas(sampler2D tex, ivec2 texcoord, float sharpness_knob)
{
    vec3 a = srgb2lin(texelFetch(tex, texcoord + ivec2(vec2(0.0, -1.0)), 0).rgb);
    vec3 b = srgb2lin(texelFetch(tex, texcoord + ivec2(vec2(-1.0, 0.0)), 0).rgb);
    vec3 c = srgb2lin(texelFetch(tex, texcoord + ivec2(vec2(.0, 0.0)), 0).rgb);
    vec3 d = srgb2lin(texelFetch(tex, texcoord + ivec2(vec2(1.0, 0.0)), 0).rgb);
    vec3 e = srgb2lin(texelFetch(tex, texcoord + ivec2(vec2(0.0, 1.0)), 0).rgb);

    float min_g = min(a.g, min(b.g, min(c.g, min(d.g, e.g))));
    float max_g = max(a.g, max(b.g, max(c.g, max(d.g, e.g))));
    float sharpening_amount = sqrt(min(1.0 - max_g, min_g) / max_g);
    float w = sharpening_amount * mix(-0.125, -0.2, sharpness_knob);

    return (w * (a + b + d + e) + c) / (4.0 * w + 1.0);
}

float aastep(float edge, float x)
{
    float aawidth = 0.7 * fwidth(x);
	return smoothstep(edge - aawidth, edge + aawidth, x);
}

void fragment()
{
    ivec2 texture_size = textureSize(TEXTURE, 0);
    ivec2 texcoord = ivec2((UV / TEXTURE_PIXEL_SIZE)) % texture_size;
    vec3 color_original = srgb2lin(texelFetch(TEXTURE, texcoord, 0).rgb);
    float sharpness_knob = sharp_strength; // adjusts the amount of sharpening, range [0,1]
    vec3 color_sharpened = cas(TEXTURE, texcoord, sharpness_knob);

    vec3 output_color = color_sharpened;

    COLOR = vec4(lin2srgb(output_color), 1.0);
}