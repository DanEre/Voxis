#version 450

layout(location = 0) in vec3 POSITION;
layout(location = 1) in vec2 TEXCOORD;
layout(location = 2) in vec4 COLOR;
layout(location = 3) in vec3 NORMAL;

uniform mat4 PROJECTION;
uniform mat4 VIEW;
uniform mat4 MODEL;

out vec2 V_TEXCOORD;
out vec4 V_COLOR;
out vec3 V_NORMAL;
out vec3 V_LOCAL_POS;

void main()
{
    gl_Position = PROJECTION * VIEW * MODEL * vec4(POSITION, 1.0);

    V_TEXCOORD = TEXCOORD;
    V_COLOR = COLOR;
    V_NORMAL = NORMAL;
    V_LOCAL_POS = POSITION;
}