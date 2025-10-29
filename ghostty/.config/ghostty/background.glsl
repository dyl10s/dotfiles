void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);

    // Subtle vignette: darken edges slightly
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    float vignette = 1.0 - dist * 0.2; // Mild darkening at edges
    color.rgb *= vignette;

    fragColor = color;
}
