//https://www.shadertoy.com/view/tsSSDc

shader_type canvas_item;


uniform float levels = 3.0;

uniform float spacing = 0.01;
uniform float frequency = 30.0;
uniform float height = 0.003;
uniform float width = 0.015;
uniform float alias = 0.002;
uniform float bright = 1.2;
uniform float dist = 0.2;
//const vec3 color = vec3(0.05,0.1,-0.15);
uniform vec3 color = vec3(0.05,0.1,-0.15);


mat2 rotate2d(float _angle) {
    return mat2(vec2(cos(_angle),-sin(_angle)),
                vec2(sin(_angle), cos(_angle)));
}

void fragment() {
	float angle = PI/levels;
    float result = 0.0;
    // normalized pixel coordinates (from 0 to 1)
//    vec2 uv = fragCoord/iResolution.xy;
	vec2 uv = UV;
    // input texture from channel 0
    vec4 tex = texture(TEXTURE, uv);
    float t = float(tex.x);
    // diagonal waves
    for (float i = 0.0; i<levels; i++) {
        // new uv coordinate
        vec2 nuv = rotate2d(angle+angle*i) * uv;
        // calculate wave
        float wave = sin(nuv.x*frequency)*height;
        float x = (spacing/2.0)+wave;
        float y = mod(nuv.y,spacing);
        // wave lines
        float line = width * (1.0-(t*bright)-(i*dist));
        float waves = smoothstep(line,line+alias,abs(x-y));
        // save the result for the next wave
        result += waves;
    }
    result /= levels;
    // increase contrast
    result = smoothstep(0.6,1.0,result);
    // add some color
    vec3 colored = vec3(result+color);
    // output to screen
    COLOR = vec4(colored,1.0);
}