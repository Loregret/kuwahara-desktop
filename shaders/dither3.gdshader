shader_type canvas_item;


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
//    vec2 uv = fragCoord/iResolution.xy;
    vec4 col = texture(TEXTURE, UV);

    // https://en.wikipedia.org/wiki/Ordered_dithering
   	int x = int(FRAGCOORD.x) % 4;
    int y = int(FRAGCOORD.y) % 4;
    
    // https://en.wikipedia.org/wiki/Luma_(video)
	float lum = dot(vec3(0.2126, 0.7152, 0.0722), col.rgb);
    lum = findClosest(x,y, lum);
 
	// Output to screen
	COLOR = vec4(lum);
}