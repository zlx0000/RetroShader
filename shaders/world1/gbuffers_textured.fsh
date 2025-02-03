/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 430

//Diffuse (color) texture.
uniform sampler2D texture;
//Lighting from day/night + shadows + light sources.
uniform sampler2D lightmap;

//RGB/intensity for hurt entities and flashing creepers.
uniform vec4 entityColor;
//0-1 amount of blindness.
uniform float blindness;
//0 = default, 1 = water, 2 = lava.
uniform int isEyeInWater;

//Vertex color.
varying vec4 color;
//Diffuse and lightmap texture coordinates.
varying vec2 coord0;
varying vec2 coord1;

float rnd(float n)
{
    int i = floatBitsToInt(n);
    int exponent = ((i >> 23) & 0xFF) - 127;
    int maskBits = max(0, 23 - 9 - exponent);
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
    //Combine lightmap with blindness.
    vec3 light = rndv3(rnd(1.-blindness) * textureLod(lightmap,rndv2(coord1), 0.0).rgb);
    //Sample texture times lighting.
    vec4 col = rndv4(rndv4(color) * vec4(light,1) * textureLod(texture,rndv2(coord0), 0.0));
    //Apply entity flashes.
    col.rgb = rndv3(mix(rndv3(col.rgb),rndv3(entityColor.rgb),rnd(entityColor.a)));

    //Calculate fog intensity in or out of water.
    //float fog = rnd((isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    //clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.));

    //Apply the fog.
    //col.rgb = mix(rndv3(col.rgb), rndv3(gl_Fog.color.rgb), fog);

    //Output the result.
    gl_FragData[0] = rndv4(col);
}
