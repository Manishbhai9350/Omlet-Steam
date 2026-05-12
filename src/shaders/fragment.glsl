
// Uniforms;
uniform sampler2D uPerlin;
uniform float uTime;

// Varyings
varying vec2 vUv;

vec3 breadColor = vec3(0.01); // light baked bread

void main() {

    vec2 pUv = vUv * vec2(.2, .2) - vec2(0.0, uTime * .03);
    vec4 pNoise = texture(uPerlin, pUv);

    // Left Fade
    float sideFades = smoothstep(0.0, .7, vUv.x);
    // Right Fade
    sideFades *= 1.0 - smoothstep(.3, 1., vUv.x);
    // Top Fade
    sideFades *= 1.0 - smoothstep(.3, 1., vUv.y);
    // Bottom Fade
    sideFades *= smoothstep(0.0, .1, vUv.y);

    float alpha = pNoise.r;
    alpha = pow(alpha, 2.0);
    alpha *= sideFades;

    if(alpha < .0001) {
        // discard;
    }

    vec3 lightPart = vec3(1.0, 0.9, 0.5);   // fluffy inside
    vec3 darkPart = vec3(0.85, 0.6, 0.2);  // slightly fried

    float t = pNoise.g;
    vec3 color = mix(lightPart, darkPart, t);
    float edge = smoothstep(0.4, 0.9, length(vUv - 0.5));
    color = mix(color, vec3(0.5, 0.3, 0.1), edge * 0.4);
    color *= vec3(1.0, 0.96, 0.84); // warm sunlight feel
    float center = 1.0 - length(vUv - 0.5);
    color += center * 0.1;

    vec3 smokeColor = vec3(1.0);
    smokeColor = breadColor;

    gl_FragColor = vec4(color, alpha);
    // gl_FragColor = vec4(sideFades,0., 0., 1.0);
}