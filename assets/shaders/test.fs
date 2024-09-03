#version 330

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
uniform sampler2D lights;
uniform sampler2D darknes;
//uniform int frame;

// Output fragment color
out vec4 finalColor;

void main()
{
    vec4 t_lights = texture(lights,fragTexCoord);
    vec4 t_darknes = texture(darknes,fragTexCoord);


    finalColor = vec4((t_darknes.rgb+t_lights.rgb), t_darknes.a-t_lights.a);


}