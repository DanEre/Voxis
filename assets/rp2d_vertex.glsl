#version 450

layout (location = 0) in vec4 POSITION;
layout (location = 1) in vec2 TEXCOORD;
layout (location = 2) in vec4 COLOR;

out vec4 v_color;
out vec2 v_texcoord;
out float v_texindex;

uniform mat4 PROJECTION;

void main()
{
	gl_Position = PROJECTION * vec4(POSITION.xyz, 1.0);
	v_color = COLOR;
	v_texcoord = TEXCOORD;
	v_texindex = POSITION.W;
}