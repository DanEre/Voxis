#version 450

in vec2 V_TEXCOORD;
in vec4 V_COLOR;
in vec3 V_NORMAL;
in vec3 V_LOCAL_POS;

out vec4 FRAG;

uniform vec4 SKY;
uniform vec4 HORIZON;

void main()
{
    float mixval = abs(V_LOCAL_POS.y);
    FRAG = mix(HORIZON, SKY, mixval);
}