#version 450

uniform sampler2D MAIN_TEX;

in vec2 V_TEXCOORD;
in vec4 V_COLOR;
in vec3 V_NORMAL;

out vec4 FRAG;

void main()
{
    vec4 texColor = texture(MAIN_TEX, V_TEXCOORD);

    FRAG = texColor * V_COLOR;

    if (FRAG.a < 0.5) discard;
}