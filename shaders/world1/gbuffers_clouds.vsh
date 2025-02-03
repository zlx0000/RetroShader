/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 430

//Model * view matrix and it's inverse.
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

//Pass vertex information to fragment shader.
varying vec4 color;
varying vec2 coord0;

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

mat3 rndm3(mat3 n)
{
    return mat3(rndv3(n[0]), rndv3(n[1]), rndv3(n[2]));
}

mat4 rndm4(mat4 n)
{
    return mat4(rndv4(n[0]), rndv4(n[1]), rndv4(n[2]), rndv4(n[3]));
}

void main()
{
    //Calculate world space position.

    mat4 glModelViewMatrixRnd = rndm4(gl_ModelViewMatrix);
    vec4 glVertexRnd = rndv4(gl_Vertex);
    mat4 gbufferModelViewRnd = rndm4(gbufferModelView);
    mat4 gbufferModelViewInverseRnd = rndm4(gbufferModelViewInverse);
    mat4 glProjectionMatrixRnd = rndm4(gl_ProjectionMatrix);
    vec4 glMultiTexCoord0Rnd = rndv4(gl_MultiTexCoord0);

    vec3 pos = rndv3((glModelViewMatrixRnd * glVertexRnd).xyz);
    pos = rndv3((gbufferModelViewInverseRnd * vec4(pos,1)).xyz);

    //Output position and fog to fragment shader.
    gl_Position = rndv4(glProjectionMatrixRnd * gbufferModelViewRnd * vec4(pos,1));
    gl_FogFragCoord = rnd(length(pos));

    //Output color to fragment shader.
    color = rndv4(gl_Color);
    //Output diffuse texture coordinates to fragment shader.
    coord0 = (rndm4(gl_TextureMatrix[0]) * glMultiTexCoord0Rnd).xy;
}
