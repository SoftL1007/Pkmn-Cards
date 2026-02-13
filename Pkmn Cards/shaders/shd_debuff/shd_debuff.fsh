varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main()
{
    vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    vec3 tint = vec3(0.6, 0.6, 1.2); 
    vec3 col_tinted = base_col.rgb * tint;
    
    float drop = sin(v_vTexcoord.y * 30.0 - u_time * 10.0);
    float x_noise = sin(v_vTexcoord.x * 20.0);
    
    float rain = smoothstep(0.8, 1.0, drop * x_noise);
    
    vec3 final_col = mix(col_tinted, vec3(0.2, 0.2, 0.5), rain * 0.5);
    
    gl_FragColor = vec4(final_col, base_col.a);
}