// https://www.shadertoy.com/view/Xdt3Dr
shader_type canvas_item;



uniform float pixel_size = 4.;

//----------------------------------------------------------------------------

float bayer8x8(sampler2D ichannel , vec2 uvScreenSpace)
{
    return texture(ichannel, uvScreenSpace/(pixel_size*8.)).r;
}


//----------------------------------------------------------------------------
// c64 palette
const vec3 color0 = vec3(0,0,0);// black
const vec3 color1 = vec3(1,1,1);// white
const vec3 color2 = vec3(0.41,0.22,0.17);// red
const vec3 color3 = vec3(0.44,0.64,0.70);// cyan
const vec3 color4 = vec3(0.44,0.24,0.53);// violet
const vec3 color5 = vec3(0.35,0.55,0.26);// green
const vec3 color6 = vec3(0.21,0.16,0.47);// blue
const vec3 color7 = vec3(0.72,0.78,0.44);// yellow
const vec3 color8 = vec3(0.44,0.31,0.15);// orange
const vec3 color9 = vec3(0.26,0.22,0);// brown
const vec3 colorA = vec3(0.60,0.40,0.35);// light red
const vec3 colorB = vec3(0.27,0.27,0.27);// grey1
const vec3 colorC = vec3(0.42,0.42,0.42);// grey2
const vec3 colorD = vec3(0.60,0.82,0.52);// light green
const vec3 colorE = vec3(0.42,0.37,0.71);// light blue
const vec3 colorF = vec3(0.58,0.58,0.58);// grey3








vec3 selectIfCloser (in vec3 idealColor, in vec3 paletteColor, in vec3 bestColorSoFar, inout float currentDistance) 
{
    float thisDistance = distance(idealColor, paletteColor);
    if(thisDistance < currentDistance)
    {
        currentDistance = thisDistance;
        return paletteColor;
    }
    return bestColorSoFar;
}

// a more optimized version of this could do something like a binary search
// or order by luminocity and short-circuit search that way.
vec3 palettize(vec3 idealColor)
{
    // init with first palette color
	float dmin = distance(idealColor, color0);
    vec3 closest = color0;

    closest = selectIfCloser(idealColor, color1, closest, dmin);
    closest = selectIfCloser(idealColor, color2, closest, dmin);
    closest = selectIfCloser(idealColor, color3, closest, dmin);
    closest = selectIfCloser(idealColor, color4, closest, dmin);
    closest = selectIfCloser(idealColor, color5, closest, dmin);
    closest = selectIfCloser(idealColor, color6, closest, dmin);
    closest = selectIfCloser(idealColor, color7, closest, dmin);
    closest = selectIfCloser(idealColor, color8, closest, dmin);
    closest = selectIfCloser(idealColor, color9, closest, dmin);
    closest = selectIfCloser(idealColor, colorA, closest, dmin);
    closest = selectIfCloser(idealColor, colorB, closest, dmin);
    closest = selectIfCloser(idealColor, colorC, closest, dmin);
    closest = selectIfCloser(idealColor, colorD, closest, dmin);
    closest = selectIfCloser(idealColor, colorE, closest, dmin);
    closest = selectIfCloser(idealColor, colorF, closest, dmin);
    return closest;
}

vec3 getSceneColor(sampler2D ichannel, in vec2 uv )
{
    return texture(ichannel, uv).rgb;
}

void fragment()
{
    vec2 uv = UV;// 0-1
    
    // space between values of the dest palette
    vec3 quantizationPeriod = vec3(1./16.);
    
	vec2 uvPixellated = floor( (UV / TEXTURE_PIXEL_SIZE) / pixel_size) * pixel_size;
    
	// original color panel---------------------
//    vec3 originalCol = getSceneColor(TEXTURE, uv);
    
    // dithered panel---------------------
    vec3 dc = getSceneColor(TEXTURE, uvPixellated / (1.0 / TEXTURE_PIXEL_SIZE).xy);
//	vec3 dc = getSceneColor(TEXTURE, uv);
	
	dc += (bayer8x8(TEXTURE, (UV / TEXTURE_PIXEL_SIZE))-.5) * (quantizationPeriod);

    dc = palettize(dc);

    COLOR = vec4(dc, 1);
}