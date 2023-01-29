#version 450

#define MAX_TEXTURES 16

in vec4 v_color;
in vec2 v_texcoord;
in float v_texindex;

out vec4 FRAGMENT;

uniform sampler2D TEXTURES[MAX_TEXTURES];

void main()
{
	sampler2D indexedSampler = TEXTURES[v_texindex];
	FRAGMENT = texture(indexedSampler, v_texcoord) * v_color;
}