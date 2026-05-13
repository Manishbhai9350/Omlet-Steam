
// Uniforms;
uniform sampler2D uPerlin;
uniform float uTime;

// Varyings
varying vec2 vUv;


void main() {

    vec2 pUv = vUv * vec2(.42, .2) - vec2(0.0, uTime * .015);
    vec4 pNoise = texture(uPerlin, pUv);

    // Left Fade
    float sideFades = smoothstep(0.0, .6, vUv.x);
    // Right Fade
    sideFades *= 1.0 - smoothstep(.4, 1., vUv.x);
    // Top Fade
    sideFades *= pow(1.0 - smoothstep(.7, 1., vUv.y),2.5);
    // Bottom Fade
    sideFades *= smoothstep(0.0, .05, vUv.y);

    float alpha = pNoise.r;
    alpha = pow(alpha, 2.3);
    alpha *= sideFades;

    if(alpha < .0001) {
        // discard;
    }

    vec3 lightPart = vec3(1.0, 0.9, 0.5);   // fluffy inside
    vec3 darkPart = vec3(0.85, 0.6, 0.2);  // slightly fried

    float t = pNoise.g;
    vec3 color = mix(lightPart, darkPart, t);
    float edge = smoothstep(0., 0.9, length(vUv - 0.5));
    color = mix(color, vec3(0.5, 0.3, 0.1), edge * 0.4);
    color *= vec3(0.74, 0.55, 0.0); // warm sunlight feel

    gl_FragColor = vec4(color, alpha);
    // gl_FragColor = vec4(sideFades,0., 0., 1.0);
    // gl_FragColor = vec4(vec3(1.0,0.0,0.0), 1.0);

}