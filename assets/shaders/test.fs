#version 330

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
//uniform sampler2D lights;
uniform sampler2D mask;
uniform vec4 world_light;
//uniform int frame;

// Output fragment color
out vec4 finalColor;

void main()
{
    vec4 t_lights = texture(mask,fragTexCoord);
   // finalColor = vec4(t_lights.rgb, 1-t_lights.a);
   
    //finalColor=vec4(world_light);
    finalColor=vec4(t_lights.rgb + world_light.rgb, 1-t_lights.a-world_light.a);

    //finalColor=mix(texelColor0,texelColor1,final);
}