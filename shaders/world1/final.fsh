#version 430

uniform sampler2D texture;
uniform vec3 cameraPosition;

varying vec4 color;
varying vec2 coord0;
varying vec3 normal;

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
    vec2 texSize = textureSize(texture, 0);
    vec2 texelUV = (floor(rndv2(coord0) * texSize) + 0.5) / texSize;
    vec4 FragColor = texture(texture, texelUV);                     //resample the texture to enforce nearest-neighbor filtering
    //gl_FragData[0] = rndv4(color * textureLod(texture, rndv2(snappedUV), 0.0));
    gl_FragData[0] = rndv4(FragColor);
}
