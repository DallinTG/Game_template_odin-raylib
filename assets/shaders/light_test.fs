#version 330

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 vertexPosition;
in vec2 uv_img_2;
in vec2 size_img_2;


in vec3 positionOS;
// Input uniform values
uniform sampler2D texture0;
uniform sampler2D light;

// Output fragment color
out vec4 finalColor;

void main()
{
    // vec4 t_bace = texture(bace,vec2(positionOS.x*-1,positionOS.y));
    vec4 t_texture0 = texture(texture0,fragTexCoord);
    vec4 t_light = texture(light,fragTexCoord+uv_img_2);
    // finalColor = t_texture0;
    finalColor = t_light;
    // finalColor = vec4(vertexPosition,1.0);
} 