shader_type canvas_item;

// c64 palette
uniform vec3 color0: source_color = vec3(0,0,0);// black
uniform vec3 color1: source_color = vec3(1,1,1);// white
uniform vec3 color2: source_color = vec3(0.41,0.22,0.17);// red
uniform vec3 color3: source_color = vec3(0.44,0.64,0.70);// cyan
uniform vec3 color4: source_color = vec3(0.44,0.24,0.53);// violet
uniform vec3 color5: source_color = vec3(0.35,0.55,0.26);// green
uniform vec3 color6: source_color = vec3(0.21,0.16,0.47);// blue
uniform vec3 color7: source_color = vec3(0.72,0.78,0.44);// yellow
uniform vec3 color8: source_color = vec3(0.44,0.31,0.15);// orange
uniform vec3 color9: source_color = vec3(0.26,0.22,0);// brown
uniform vec3 colorA: source_color = vec3(0.60,0.40,0.35);// light red
uniform vec3 colorB: source_color = vec3(0.27,0.27,0.27);// grey1
uniform vec3 colorC: source_color = vec3(0.42,0.42,0.42);// grey2
uniform vec3 colorD: source_color = vec3(0.60,0.82,0.52);// light green
uniform vec3 colorE: source_color = vec3(0.42,0.37,0.71);// light blue
uniform vec3 colorF: source_color = vec3(0.58,0.58,0.58);// grey3


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
	vec3 dc = getSceneColor(TEXTURE, UV);
	dc = palettize(dc);
	COLOR = vec4(dc, 1);
}