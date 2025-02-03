/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 430

//0-1 amount of blindness.
uniform float blindness;
//0 = default, 1 = water, 2 = lava.
uniform int isEyeInWater;

//Vertex color.
varying vec4 color;

float rnd(float n)
{
    int i = floatBitsToInt(n);
    int exponent = ((i >> 23) & 0xFF) - 127;
    int maskBits = max(0, 23 - 10 - exponent);
    int mask = -1 << maskBits;
    return intBitsToFloat(i & mask);
}

vec2 rndv2(vec2 v)
{
    return vec2(rnd(v.x), rnd(v.y));
}

vec3 rndv3(vec3 v)
{
    return vec3(rnd(v.x), rnd(v.y), rnd(v.z));
}

vec4 rndv4(vec4 v)
{
    return vec4(rnd(v.x), rnd(v.y), rnd(v.z), rnd(v.w));
}

void main()
{
    vec4 col = rndv4(color);

    //Calculate fog intensity in or out of water.
    //float fog = rnd((isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    //clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.));

    //Apply the fog.
    //col.rgb = rndv3(mix(col.rgb, gl_Fog.color.rgb, fog));

    //Output the result.
    gl_FragData[0] = rndv4(col * vec4(vec3(1.-blindness),1));
}
