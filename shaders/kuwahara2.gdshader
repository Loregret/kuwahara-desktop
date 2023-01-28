// https://www.shadertoy.com/view/ddlXz4
shader_type canvas_item;

uniform int radius : hint_range(0, 20, 0.01) = 3; // radius :, min=0, max=100.

void fragment()
{
    vec2 iChannel0_size = vec2((1.0/TEXTURE_PIXEL_SIZE).x, (1.0/TEXTURE_PIXEL_SIZE).y);
    vec2 uv = (UV / TEXTURE_PIXEL_SIZE) / (1.0/TEXTURE_PIXEL_SIZE).xy;
    float n = float((radius + 1) * (radius + 1));

    vec3 m[4];
    vec3 s[4];
    for (int k = 0; k < 4; ++k) {
        m[k] = vec3(0.0);
        s[k] = vec3(0.0);
    }

    for (int j = -radius; j <= 0; ++j)  {
        for (int i = -radius; i <= 0; ++i)  {
            vec3 c = texture(TEXTURE, uv + vec2(float(i), float(j)) / iChannel0_size).rgb;
            m[0] += c;
            s[0] += c * c;
        }
    }

    for (int j = -radius; j <= 0; ++j)  {
        for (int i = 0; i <= radius; ++i)  {
            vec3 c = texture(TEXTURE, uv + vec2(float(i), float(j)) / iChannel0_size).rgb;
            m[1] += c;
            s[1] += c * c;
        }
    }

    for (int j = 0; j <= radius; ++j)  {
        for (int i = 0; i <= radius; ++i)  {
            vec3 c = texture(TEXTURE, uv + vec2(float(i), float(j)) / iChannel0_size).rgb;
            m[2] += c;
            s[2] += c * c;
        }
    }

    for (int j = 0; j <= radius; ++j)  {
        for (int i = -radius; i <= 0; ++i)  {
            vec3 c = texture(TEXTURE, uv + vec2(float(i), float(j)) / iChannel0_size).rgb;
            m[3] += c;
            s[3] += c * c;
        }
    }


    float min_sigma2 = 1e+2;
    for (int k = 0; k < 4; ++k) {
        m[k] /= n;
        s[k] = abs(s[k] / n - m[k] * m[k]);

        float sigma2 = s[k].r + s[k].g + s[k].b;
        if (sigma2 < min_sigma2) {
            min_sigma2 = sigma2;
            COLOR = vec4(m[k], 1.0);
        }
    }
}
