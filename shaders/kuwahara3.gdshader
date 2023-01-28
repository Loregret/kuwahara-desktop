// https://www.shadertoy.com/view/ltyyDd
shader_type canvas_item;


const int N = 8;
const float HALF_SQRT2 = 0.7071067811865475244f;

uniform float radius : hint_range(0.0, 45.0, 0.1) = 3.0;
uniform float alpha = 1.0;
uniform float q = 8.0;

void fragment()
{
	
    vec2 src_size = (1.0 / TEXTURE_PIXEL_SIZE).xy;
    vec2 uv = (UV / TEXTURE_PIXEL_SIZE)/src_size;

    vec4 t = texture(TEXTURE, uv);
    float a = radius * clamp((alpha + t.w) / alpha, 0.1, 2.0); 
    float b = radius * clamp(alpha / (alpha + t.w), 0.1, 2.0);

    float cos_phi = cos(t.z);
    float sin_phi = sin(t.z);

    mat2 SR = mat2(vec2(cos_phi/a, -sin_phi/b), vec2(sin_phi/a, cos_phi/b));
    
    float aa = a * a;
	float bb = b * b;
	float coscos_phi = cos_phi * cos_phi;
	float sinsin_phi = sin_phi * sin_phi;
	
	int max_x = int(sqrt(aa * coscos_phi + bb * sinsin_phi));
	int max_y = int(sqrt(aa * sinsin_phi + bb * coscos_phi));

    vec4 m[8];
    vec3 s[8];
	
    {
    	vec3 c = texture(TEXTURE, uv).rgb;
        float w = 1.0f / float(N);
        for (int k = 0; k < N; ++k) {
            m[k] =  vec4(c * w, w);
            s[k] = c * c * w;
        }
    }

    for (int j = 0; j <= max_y; ++j)  {
        for (int i = -max_x; i <= max_x; ++i) {
            if ((j !=0) || (i > 0)) {
                vec2 v = SR * vec2(float(i),float(j));
                
                float dotv = dot(v,v);

                if (dotv <= 1.0f) {
                    vec3 c0 = texture(TEXTURE, uv + vec2(float(i),float(j))/src_size).rgb;
                    vec3 c1 = texture(TEXTURE, uv - vec2(float(i), float(j))/src_size).rgb;

                    vec3 cc0 = c0 * c0;
                    vec3 cc1 = c1 * c1;

                    float sum = 0.0f;
					float w[8];
					float z, vxx, vyy;
					
					vxx = 0.33f - 3.77f * v.x * v.x;
					vyy = 0.33f - 3.77f * v.y * v.y;
					z = max(0.0f,  v.y + vxx); sum += w[0] = z * z;
					z = max(0.0f, -v.x + vyy); sum += w[2] = z * z;
					z = max(0.0f, -v.y + vxx); sum += w[4] = z * z;
					z = max(0.0f,  v.x + vyy); sum += w[6] = z * z;

					v = HALF_SQRT2 * vec2( v.x - v.y, v.x + v.y );

					vxx = 0.33f - 3.77f * v.x * v.x;
					vyy = 0.33f - 3.77f * v.y * v.y;
					z = max(0.0f,  v.y + vxx); sum += w[1] = z * z;
					z = max(0.0f, -v.x + vyy); sum += w[3] = z * z;
					z = max(0.0f, -v.y + vxx); sum += w[5] = z * z;
					z = max(0.0f,  v.x + vyy); sum += w[7] = z * z;

					float g = exp(-3.125f * dotv) / sum;
					
					for (int k = 0; k < N; ++k) {
						float wk = w[k] * g;
						m[k] += vec4(c0 * wk, wk);
						s[k] += cc0 * wk;
						m[(k+4)&7] += vec4(c1 * wk, wk);
						s[(k+4)&7] += cc1 * wk;
					}
                }
            }
        }
    }
    
    
    vec4 o = vec4(0.0);
    for (int k = 0; k < N; ++k) {
        m[k].rgb /= m[k].w;
        s[k] = abs(s[k] / m[k].w - m[k].rgb * m[k].rgb);

        float sigma2 = s[k].r + s[k].g + s[k].b;
        float w = 1.0 / (1.0 + pow(255.0 * sigma2, 0.5 * q));

        o += vec4(m[k].rgb * w, w);
    }

    COLOR = vec4(o.rgb / o.w, 1.0);
}