shader_type canvas_item;

uniform int levels = 4;

uniform float luma_r = 0.2126;
uniform float luma_g = 0.7152;
uniform float luma_b = 0.0722;

const mat4 threshold = mat4(vec4(0., 8., 2., 10.), 
                            vec4(12., 4., 14., 6.),
                            vec4(3.,11.,1.,9.),
                            vec4(15.,7.,13., 5.));


float findClosest(int x, int y, float v)
{
    mat4 thresholdT = transpose(threshold);
    float t = (thresholdT[x][y]) / 16.;
    if(v < t)
    {
      	return 0.;   
    }
    else
    {
     	return 1.;   
    }
}


void fragment( )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec4 col = texture(TEXTURE, UV);

    // https://en.wikipedia.org/wiki/Ordered_dithering
    int x = int(FRAGCOORD.x) % levels;
    int y = int(FRAGCOORD.y) % levels;
    
    // https://en.wikipedia.org/wiki/Luma_(video)
    float lum = dot(vec3(luma_r, luma_g, luma_b), col.rgb);
    lum = findClosest(x,y, lum);
 

    COLOR = vec4(lum);
}