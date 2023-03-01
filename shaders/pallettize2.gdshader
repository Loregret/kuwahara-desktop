shader_type canvas_item;

uniform vec3[6] pallette: source_color;

uniform vec4 color1:source_color = vec4(0.152, 0.152, 0.26, 1.);
uniform vec4 color2:source_color = vec4(0.28, 0.301, 0.49, 1.);
uniform vec4 color3:source_color = vec4(0.545, 0.427, 0.61, 1.);
uniform vec4 color4:source_color = vec4(0.77, 0.62, 0.64, 1.);
uniform vec4 color5:source_color = vec4(0.94, 0.82, 0.67, 1.);
uniform vec4 color6:source_color = vec4(0.98, 0.96, 0.937, 1.);

//const vec4[6] pallette_array2 = { 
//vec4(39./255., 39./255., 68./255., 1.), 
//vec4(73./255., 77./255., 126./255., 1.), 
//vec4(139./255., 109./255., 156./255.,1.), 
//vec4(198./255., 159./255., 165./255., 1.),
//vec4(242./255., 211./255., 171./255., 1.),
//vec4(251./255., 245./255., 239./255., 1.)
//};

vec4 applyPalette(float lum, int colors)
{
	vec4 d = vec4(255,255,255,1);
	vec4 pallette_array[6] = { color1, color2, color3, color4 , color5 , color6 };
	
	lum = floor( lum * float(colors) );
	return pallette_array[ int(lum) ];
}

void fragment()
{
	int colors = int( 6 );
	vec4 col = texture(TEXTURE, UV);
	float lum = (0.299 * col.r + 0.587 * col.g + 0.114 * col.b);
	col = applyPalette(lum, colors);
	COLOR = vec4(col);
}