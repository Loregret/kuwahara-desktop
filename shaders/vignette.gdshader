// https://www.shadertoy.com/view/Mdsfzl
shader_type canvas_item;

uniform float rEnable = 0.0;
uniform float gEnable = 0.0;
uniform float bEnable = 0.0;

uniform	float OuterVig = 1.0; // Position for the Outer vignette
uniform	float InnerVig = 0.5; // Position for the inner Vignette Ring


void fragment()
{
	
	vec4 color = texture(TEXTURE, UV);
	vec2 center = vec2(0.5, 0.5); // Center of Screen
    
	float dist  = distance(center, UV) * 1.414213; // Distance  between center and the current Uv. Multiplyed by 1.414213 to fit in the range of 0.0 to 1.0 
	float vig = clamp((OuterVig-dist) / (OuterVig-InnerVig), 0.0, 1.0); // Generate the Vignette with Clamp which go from outer Viggnet ring to inner vignette ring with smooth steps
	
    if ( abs(vig - 1.0) < 0.0001 ) {
    	COLOR = color;
    }
    else{
        color *= vig;
        color.r += (1.0 - vig) * rEnable;
        color.g += (1.0 - vig) * gEnable;
        color.b += (1.0 - vig) * bEnable;
    	COLOR = color;
    }
}