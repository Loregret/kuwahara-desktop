// https://www.shadertoy.com/view/4tcGW2
shader_type canvas_item;

const mat3 YUVFromRGB = mat3(
   vec3(0.299,-0.14713, 0.615),
   vec3(0.587,-0.28886,-0.51499),
   vec3(0.114,0.436,-0.10001));

const mat3 RGBFromYUV = mat3(
    vec3(1, 1, 1),
    vec3(0.0,-0.394,2.03211),
    vec3(1.13983,-0.580,0.0));

float extractLuma(vec3 c)
{
    return c.r * 0.299 + c.g * 0.587 + c.b * 0.114;
}

void fragment( )
{
    vec2 imgSize = vec2(512.0);
    vec4 s = texture(TEXTURE, UV);
    vec3 yuv = YUVFromRGB * s.rgb;
    
    float accumY = 0.0; 
    for(int i = -1; i <= 1; ++i) {
        for(int j = -1; j <= 1; ++j) {
            vec2 offset = vec2(float(i), float(j)) / imgSize;
            
            float s = extractLuma(texture(TEXTURE,UV + offset).rgb);
            float notCentre = min(float(i*i + j*j), 1.0);
            accumY += s * (9.0 - notCentre * 10.0);
        }
    }
    
    accumY /= 9.0;
    
    float gain = 0.9;
    accumY = (accumY + yuv.x) * gain;
    
	COLOR = vec4(RGBFromYUV * vec3(accumY, yuv.y, yuv.z), 1.0); // sharpened

}