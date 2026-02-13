varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main()
{
    vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    // Create a diagonal sheen effect
    float sheen = sin((v_vTexcoord.x + v_vTexcoord.y) * 10.0 - u_time * 5.0);
    float highlight = smoothstep(0.8, 1.0, sheen) * 0.6; 
    
    vec3 final_col = base_col.rgb + vec3(0.1, 0.1, 0.2); 
    final_col += vec3(highlight);
    
    gl_FragColor = vec4(final_col, base_col.a);
}