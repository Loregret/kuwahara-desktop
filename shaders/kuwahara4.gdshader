shader_type canvas_item;

uniform sampler2D iChannel1;


uniform bool DEBUG_VIEW_STRUCTURE_TENSOR = false;
uniform bool SMOOTHED_STRUCTURE_TENSOR = true;


vec3 gauss (vec2 uv, vec2 src_size, float sigma, sampler2D iChannel0) {
if (SMOOTHED_STRUCTURE_TENSOR) {
	    float twoSigma2 = 2.0 * sigma * sigma;
	    int halfWidth = int(ceil( 2.0 * sigma ));

	    vec3 sum = vec3(0.0);
	    float norm = 0.0;
	    if (halfWidth > 0) {
	        for ( int i = -halfWidth; i <= halfWidth; ++i ) {
	            for ( int j = -halfWidth; j <= halfWidth; ++j ) {
	                float d = length(vec2(float(i),float(j)));
	                float kernel = exp( -d *d / twoSigma2 );
	                vec3 c = texture(iChannel0, uv + vec2(float(i),float(j)) / src_size ).rgb;
	                sum += kernel * c;
	                norm += kernel;
	            }
	        }
	    } else {
	        sum = texture(iChannel0, uv).rgb;
	        norm = 1.0;
	    }
	    return sum / norm;
	} else {
	    return texture(iChannel0, uv).rgb;
	}
}


void bufferA(out vec4 fragColor, in vec2 fragCoord, vec2 iResolution, sampler2D iChannel0, vec2 uv)
{
    vec2 src_size = iResolution.xy;

	uv = uv/src_size;
	
    vec2 d = 1.0 / src_size;

//    vec3 c = texture(iChannel0, uv).xyz;
    vec3 u = (
           -1.0 * texture(iChannel0, uv + vec2(-d.x, -d.y)).xyz +
           -2.0 * texture(iChannel0, uv + vec2(-d.x,  0.0)).xyz + 
           -1.0 * texture(iChannel0, uv + vec2(-d.x,  d.y)).xyz +
           +1.0 * texture(iChannel0, uv + vec2( d.x, -d.y)).xyz +
           +2.0 * texture(iChannel0, uv + vec2( d.x,  0.0)).xyz + 
           +1.0 * texture(iChannel0, uv + vec2( d.x,  d.y)).xyz
           ) / 4.0;

    vec3 v = (
           -1.0 * texture(iChannel0, uv + vec2(-d.x, -d.y)).xyz + 
           -2.0 * texture(iChannel0, uv + vec2( 0.0, -d.y)).xyz + 
           -1.0 * texture(iChannel0, uv + vec2( d.x, -d.y)).xyz +
           +1.0 * texture(iChannel0, uv + vec2(-d.x,  d.y)).xyz +
           +2.0 * texture(iChannel0, uv + vec2( 0.0,  d.y)).xyz + 
           +1.0 * texture(iChannel0, uv + vec2( d.x,  d.y)).xyz
           ) / 4.0;

    vec3 col = vec3(dot(u, u), dot(v, v), dot(u, v));
    //col = floor(col * 255.0) / 255.0;	// denoise
    fragColor = vec4(col, 1.0);
}


const int N = 8;
const float HALF_SQRT2 = 0.7071067811865475244f;

uniform float radius = 4.0;
const float alpha = 1.0;
const float q = 8.0;

void image(out vec4 fragColor, in vec2 fragCoord, vec2 iResolution, sampler2D iChannel0, vec2 uv)
{
    vec2 src_size = iResolution.xy;

	uv = uv/src_size;

    vec4 t = texture(iChannel1, uv);
    float a = radius * clamp((alpha + t.w) / alpha, 0.1, 2.0); 
    float b = radius * clamp(alpha / (alpha + t.w), 0.1, 2.0);

    float cos_phi = cos(t.z);
    float sin_phi = sin(t.z);

    mat2 SR = mat2(vec2(cos_phi/a, -sin_phi/b),vec2(sin_phi/a, cos_phi/b));

    float aa = a * a;
	float bb = b * b;
	float coscos_phi = cos_phi * cos_phi;
	float sinsin_phi = sin_phi * sin_phi;

	int max_x = int(sqrt(aa * coscos_phi + bb * sinsin_phi));
	int max_y = int(sqrt(aa * sinsin_phi + bb * coscos_phi));


    vec4 m[8];
    vec3 s[8];
    {
    	vec3 c = texture(iChannel0, uv).rgb;
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
                    vec3 c0 = texture(iChannel0, uv + vec2(float(i),float(j))/src_size).rgb;
                    vec3 c1 = texture(iChannel0, uv - vec2(float(i),float(j))/src_size).rgb;

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

    fragColor = vec4(o.rgb / o.w, 1.0);
}


uniform float sigma = 2.5;

void bufferB(out vec4 fragColor, in vec2 fragCoord, vec2 iResolution, sampler2D iChannel0, vec2 uv)
{
    vec2 src_size = iResolution.xy;

	uv = uv/src_size;
	
	if (DEBUG_VIEW_STRUCTURE_TENSOR) {
	    fragColor = vec4(gauss(uv, src_size, sigma, iChannel0), 1.0);
		} else {
		    vec3 g = gauss(uv, src_size, sigma, iChannel0).xyz;

		    float lambda1 = 0.5 * (g.y + g.x +
		        sqrt(g.y*g.y - 2.0*g.x*g.y + g.x*g.x + 4.0*g.z*g.z));
		    float lambda2 = 0.5 * (g.y + g.x -
		        sqrt(g.y*g.y - 2.0*g.x*g.y + g.x*g.x + 4.0*g.z*g.z));

		    vec2 v = vec2(lambda1 - g.x, -g.z);
		    vec2 t;
		    if (length(v) > 0.0) { 
		        t = normalize(v);
		    } else {
		        t = vec2(0.0, 1.0);
		    }

		    float phi = atan(t.y, t.x);

		    float A = (lambda1 + lambda2 > 0.0)?
		        (lambda1 - lambda2) / (lambda1 + lambda2) : 0.0;

		    fragColor = vec4(t, phi, A);
		}
}


void fragment()
{
//	bufferA(COLOR, FRAGCOORD.xy, 1.0 / TEXTURE_PIXEL_SIZE, TEXTURE, (UV / TEXTURE_PIXEL_SIZE));
//	bufferB(COLOR, FRAGCOORD.xy, 1.0 / TEXTURE_PIXEL_SIZE, TEXTURE, (UV / TEXTURE_PIXEL_SIZE));
	image(COLOR, FRAGCOORD.xy, 1.0 / TEXTURE_PIXEL_SIZE, TEXTURE, (UV / TEXTURE_PIXEL_SIZE));
}