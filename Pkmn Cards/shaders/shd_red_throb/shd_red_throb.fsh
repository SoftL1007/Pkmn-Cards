varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time; // Provided by object

void main()
{
    vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    // Smooth Sine wave for pulsing (0.0 to 1.0 range over time)
    float pulse = (sin(u_time * 3.0) + 1.0) * 0.5;
    
    // Target Color: Dark Red glow
    vec3 red_tint = vec3(0.8, 0.2, 0.2);
    
    // Mix strength: fluctuate between 0.0 (normal) and 0.4 (tinted)
    float strength = pulse * 0.4;
    
    vec3 final_rgb = mix(base_col.rgb, red_tint, strength);
    
    gl_FragColor = vec4(final_rgb, base_col.a);
}