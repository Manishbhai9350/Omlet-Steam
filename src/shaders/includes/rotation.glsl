vec2 rotate2D(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);

    mat2 rot = mat2(
        c, s,
        -s,  c
    );

    return rot * p;
}