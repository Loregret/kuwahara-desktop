// https://www.shadertoy.com/view/stdyRX
shader_type canvas_item;


// What power of 2 the pixel cell sizes are increased to
uniform int pixel_scale = 2;

// https://lospec.com/palette-list/oil-6
// Should be sorted in increasing order by perceived luminance for best results
// Can work with up to 256 distinct colors
const vec4[] palette = { 
vec4(39./255., 39./255., 68./255., 1.), 
vec4(73./255., 77./255., 126./255., 1.), 
vec4(139./255., 109./255., 156./255.,1.), 
vec4(198./255., 159./255., 165./255., 1.),
vec4(242./255., 211./255., 171./255., 1.),
vec4(251./255., 245./255., 239./255., 1.)};

// Amount of colors in the palette
// Changing this is not recommended


// How much the dither effect spreads. By default it is set to decrease as the amount of colors increases.
// Set to 0 to disable the dithering effect for flat color areas.


// Precomputed threshold map for dithering
const mat4 threshold = mat4( vec4(0., 8., 2., 10.), 
                                vec4(12., 4., 14., 6.),
                                vec4(3.,11.,1.,9.),
                                vec4(15.,7.,13., 5.));

// Chooses a color from the palette based on the current luminance
vec4 applyPalette(float lum, int colors)
{
    lum = floor(lum * float(colors));
    return palette[int(lum)];
}

void fragment()
{
	const int colors = int(palette.length());
	const float dither_spread = 1./float(colors);
	vec2 iResolution = 1.0 / TEXTURE_PIXEL_SIZE;
    // https://luka712.github.io/2018/07/01/Pixelate-it-Shadertoy-Unity/
    float pixelSizeX = 1.0 / iResolution.x;
    float pixelSizeY = 1.0 / iResolution.y;
    float cellSizeX = pow(2., float(pixel_scale)) * pixelSizeX;
    float cellSizeY = pow(2., float(pixel_scale)) * pixelSizeY;

    // Normalized pixel coordinates (from 0 to 1)
//    vec2 uv = FRAGCOORD.xy / iResolution.xy;
    vec2 uv = (UV / TEXTURE_PIXEL_SIZE) / iResolution.xy;
//	vec2 uv = UV;
    
    // Convert pixel coordinates to cell coordinates
    float u = cellSizeX * floor(uv.x / cellSizeX);
    float v = cellSizeY * floor(uv.y / cellSizeY);
    
    // get pixel information from the cell coordinates
    vec4 col = texture(TEXTURE, vec2(u,v));
    
    // https://en.wikipedia.org/wiki/Ordered_dithering
    int x = int(u / cellSizeX) % 4;
    int y = int(v / cellSizeY) % 4;
    col.r = col.r + (dither_spread * ((threshold[x][y]/16.) -.5));
    col.g = col.g + (dither_spread * ((threshold[x][y]/16.) -.5));
    col.b = col.b + (dither_spread * ((threshold[x][y]/16.) -.5));
    col.r = floor(col.r * float(colors-1) + .5)/float(colors-1);
    col.g = floor(col.g * float(colors-1) + .5)/float(colors-1);
    col.b = floor(col.b * float(colors-1) + .5)/float(colors-1);
    
    // Calculate luminance
    float lum = (0.299*col.r + 0.587*col.g + 0.114*col.b);
    
    // Apply the new color palette
    col = applyPalette(lum, colors);

    // Output to screen
    COLOR = vec4(col);
}