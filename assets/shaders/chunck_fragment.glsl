#version 450

uniform sampler2DArray MAIN_TEX;

uniform vec3 SUN_DIR;
uniform vec4 SUN_COLOR;
uniform vec4 AMBIENT_COLOR;
uniform vec4 FOG_COLOR;
uniform float FOG_DENSITY;

in vec2 V_TEXCOORD;
in vec2 V_TEXINDEX;
in vec4 V_COLOR;
in vec3 V_NORMAL;

// Required for Fog calculation
in vec4 V_POS_EYESPACE;

out vec4 FRAG;

float get_fog_factor(float fogCoord)
{
    float factor = 1.0 - clamp(exp(-pow(FOG_DENSITY * fogCoord, 2.0)), 0.0, 1.0);
    return factor;
}

vec4 apply_lighting(vec4 baseColor, vec3 normal)
{
    vec3 lightDir = normalize(-SUN_DIR);
    float diff = max(dot(V_NORMAL, lightDir), 0.0);

    return baseColor * AMBIENT_COLOR + baseColor * SUN_COLOR * diff * V_COLOR.a;
}

void main()
{
    // Sample main color texture
    vec4 texColor = texture(MAIN_TEX, vec3(V_TEXCOORD, V_TEXINDEX.x));

    // Apply Lighting
    texColor = apply_lighting(texColor, V_NORMAL);

    // Apply Fog
    float fogCoord = length(V_POS_EYESPACE);
    float fogFactor = get_fog_factor(fogCoord);

    // Final Output
    FRAG = mix(texColor, FOG_COLOR, fogFactor);
}