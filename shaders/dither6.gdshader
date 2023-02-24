//https://www.shadertoy.com/view/slsyz8
shader_type canvas_item;

   //Parameters
   uniform float scale = 0.0;
   uniform float quality = 5.0;


   uniform vec3 lowcolor = vec3(0.2, 0.05, 0.04);
   uniform vec3 highcolor = vec3(0.9, 0.9, 0.9);
//   uniform vec3 lowcolor = vec3(58., 13., 12.);
//   uniform vec3 highcolor = vec3(230., 241., 237.);

void fragment()
{
    
    //Color Pallete
//    vec4 low = vec4(lowcolor.x/255.0, lowcolor.y/255.0, lowcolor.z/255.0, 1.0);
//    vec4 high = vec4(highcolor.x/255.0, highcolor.y/255.0, highcolor.z/255.0, 1.0);
    vec4 low = vec4(lowcolor.x, lowcolor.y, lowcolor.z, 1.0);
    vec4 high = vec4(highcolor.x, highcolor.y, highcolor.z, 1.0);
    
    //ACTUAL CODE
    float scaleSq = pow(2.0, scale);

    vec4 fragCoord = floor(FRAGCOORD/scaleSq) * scaleSq;
    vec2 uv = UV;

    vec4 col = texture(TEXTURE, uv);
    float bw = .3*col.r + .59*col.g + .11*col.b;
    bw = floor(bw * quality)/quality;
    

    float perc = bw;
    float c = 1.0 - floor(2.0*perc);
    perc = perc - 2.0*c*perc + c; //Cool little formula to change x (c=0) to 1-x (c=1)
    
    float each = 1.0/(1.0 - perc);
    
    vec2 v = floor((mod(fragCoord.xy, each)+1.0)/each);
    
    v = 1.0 - v;
    
//    float c1 = 1.0 - c;
    float sm = v.x + v.y;
    
    sm = sm - 2.0*c*sm + c;
    sm = clamp(sm, 0.0, 1.0);
    
    col = mix(low, high, sm);

    //fragColor = vec4(bw);
    COLOR = col;
}