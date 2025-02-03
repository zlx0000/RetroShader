/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 430

//Get Entity id.
attribute float mc_Entity;

//Model * view matrix and it's inverse.
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

//Pass vertex information to fragment shader.
varying vec4 color;
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
    mat4 glProjectionMatrixRnd = rndm4(gl_ProjectionMatrix);
    mat3 glNormalMatrixRnd = rndm3(gl_NormalMatrix);
    vec3 glNormalRnd = rndv3(gl_Normal);

    vec4 glMultiTexCoord0Rnd = rndv4(gl_MultiTexCoord0);
    vec4 glMultiTexCoord1Rnd = rndv4(gl_MultiTexCoord1);
    mat4 gbufferModelViewRnd = rndm4(gbufferModelView);
    mat4 gbufferModelViewInverseRnd = rndm4(gbufferModelViewInverse);

    vec3 pos = rndv3((glModelViewMatrixRnd * glVertexRnd).xyz);
    pos = rndv3((gbufferModelViewInverseRnd * vec4(pos,1)).xyz);
    //Output position and fog to fragment shader.
    gl_Position = rndv4(glProjectionMatrixRnd * gbufferModelViewRnd * vec4(pos,1));
    gl_FogFragCoord = rnd(length(pos));

    //Calculate view space normal.
    vec3 normal = rndv3(glNormalMatrixRnd * glNormalRnd);
    //Use flat for flat "blocks" or world space normal for solid blocks.
    normal = rndv3((mc_Entity==1.) ? vec3(0,1,0) : (gbufferModelViewInverse * vec4(normal,0)).xyz);

    //Calculate simple lighting. Thanks to @PepperCode1
    float light = rnd(min(normal.x * normal.x * 0.6f + normal.y * normal.y * 0.25f * (3.0f + normal.y) + normal.z * normal.z * 0.8f, 1.0f));

    //Output color with lighting to fragment shader.
    color = rndv4(vec4(gl_Color.rgb * light, gl_Color.a));
    //Output diffuse and lightmap texture coordinates to fragment shader.
    coord0 = rndv2((rndm4(gl_TextureMatrix[0]) * glMultiTexCoord0Rnd).xy);
    coord1 = rndv2((rndm4(gl_TextureMatrix[1]) * glMultiTexCoord1Rnd).xy);
}
