

#ifdef GL_ES
precision mediump float;
#endif

uniform float life;
uniform float max_life;
uniform int particle_count;

float circle(vec2 position,float radius){
    return step(radius,length(position-vec2(.5)));
}


void main(){

    vec2 position = gl_FragCoord.xy /199.1 ;
    vec3 color = vec3(0.0);
    color = mix(vec3(1.0, 0.0, 0.0),vec3(0.0, 0.0, 1.0),circle(position,1.0));
    gl_FragColor = vec4(color, 1.0);
}


