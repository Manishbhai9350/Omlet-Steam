#define PI 3.1415926

// Uniforms;
uniform sampler2D uPerlin;
uniform float uTime;

// Varyings
varying vec2 vUv;

#include ./includes/rotation.glsl


void main(){
    vUv = uv;
    vec3 pos = position;

    // Twist 
    vec2 TwistUV = vec2(.5 + sin(uTime * .1) * .01, vUv.y * .1 - uTime * .006);
    float TwistNoise = texture(uPerlin,TwistUV).r;
    float twist = TwistNoise * 10.0 + PI/2.0;
    pos.xz = rotate2D(pos.xz, twist);

    // Adding XZ Movement ( Wind )
    // Wind X
    vec2 WindXUV = vec2(.1, vUv.y * .1 + uTime * .006);
    float WindXNoise = texture(uPerlin,WindXUV).r;
    float WindX = (WindXNoise - .5) * 2.0 * 10.0 * pow(vUv.y,2.0);
    pos.x += WindX;

    // Wind Z
    vec2 WindZUV = vec2(.2, vUv.y * .1 + uTime * .006);
    float WindZNoise = texture(uPerlin,WindZUV).r;
    float WindZ = (WindZNoise - .5) * 2.0 * 10.0 * pow(vUv.y,2.0);
    pos.z += WindZ;


    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos,1.0);
}