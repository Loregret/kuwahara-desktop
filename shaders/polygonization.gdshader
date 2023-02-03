shader_type canvas_item;

//https://www.shadertoy.com/view/4lsXR7
//reference https://www.shadertoy.com/view/ldl3W8#

vec2 hash2( vec2 p )
{
    // procedural white noise	
	return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

vec2 voronoi( in vec2 x )
{
    vec2 n = floor(x);
    vec2 f = fract(x);

    //----------------------------------
    // regular voronoi
    //----------------------------------
	vec2 mg, mr;

    float md = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 g = vec2(float(i),float(j));
		vec2 o = hash2( n + g );	
        vec2 r = g + o - f;
        float d = dot(r,r);

        if( d<md )
        {
            md = d;
            mr = r;
            mg = g;
        }
    }

    return mr;
}

vec3 VoronoiColor(float steps, vec2 p, vec2 uv, vec2 iResolution, sampler2D iChannel0)
{
    vec2 c = voronoi( steps*p );
    
    vec2 uv1 = uv;
    uv1.x += c.x/steps;
    uv1.y += c.y/steps *  iResolution.x/iResolution.y;
    
    return texture(iChannel0, vec2(uv1.x, uv1.y)).xyz;
}

uniform float steps = 255.0;

void fragment( )
{
	vec2 iResolution = (1.0 / SCREEN_PIXEL_SIZE);
    vec2 p = FRAGCOORD.xy / iResolution.xx;
//    vec2 uv = FRAGCOORD.xy / iResolution.xy;
	vec2 uv = UV;
    
    vec3 color = vec3(0.0,0.0,0.0);
    for (float i=0.0; i<4.0; i+=1.0)
    {
        float _steps = steps * pow(2.0,i);
        color += VoronoiColor(_steps, p, uv, iResolution, TEXTURE);
    }

	COLOR = vec4(color*0.25,1.0);
}