// https://www.shadertoy.com/view/MsV3Rd
shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 100, 0.1) = 4.0;

void fragment()
{
    vec2 diffFragCoordXY = (UV / TEXTURE_PIXEL_SIZE);
    
	vec2 uv = (UV / TEXTURE_PIXEL_SIZE).xy / (1.0 / TEXTURE_PIXEL_SIZE).xy;
    vec2 uv2 = uv;
    
    
    vec4 fragColorAtCoord = texture(TEXTURE, uv);
    
    vec4 currentColor = vec4(0.0, 0.0, 0.0, 1.0);
    

    
    int posX = int(ceil(mod(floor((UV / TEXTURE_PIXEL_SIZE).x), pixel_size)));
    int posY = int(ceil(mod(floor((UV / TEXTURE_PIXEL_SIZE).y), pixel_size)));

    
    if ((posX == 0) && (posY == 0))
    {
        currentColor = fragColorAtCoord;
    }
    else
    {
        diffFragCoordXY = vec2((UV / TEXTURE_PIXEL_SIZE).x - float(posX), (UV / TEXTURE_PIXEL_SIZE).y - float(posY));
        
        uv2 = diffFragCoordXY / (1.0 / TEXTURE_PIXEL_SIZE).xy;

        currentColor = texture(TEXTURE, uv2);
    }
    COLOR = currentColor;
}
