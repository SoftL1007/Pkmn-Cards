varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main()
{
    // 1. Wavy Distortion (Sine wave based on Y coordinate and Time)
    float wave_amount = 0.02; // How far pixels move left/right
    float wave_speed = 10.0;
    float wave_freq = 20.0;   // How many waves appear vertically
    
    float offset_x = sin(v_vTexcoord.y * wave_freq + u_time * wave_speed) * wave_amount;
    
    vec2 coord = v_vTexcoord;
    coord.x += offset_x;
    
    // 2. Get Color
    vec4 base_col = texture2D(gm_BaseTexture, coord);
    
    // 3. Glow / Hologram Effect (Add cyan/white tint)
    // We pulse the glow slightly
    float glow_pulse = 0.2 + (sin(u_time * 5.0) * 0.1); 
    vec3 glow_col = vec3(0.2, 0.8, 1.0) * glow_pulse; // Cyan tint
    
    // Apply Glow only where there is sprite (alpha > 0)
    base_col.rgb += glow_col * base_col.a;
    
    gl_FragColor = base_col * v_vColour;
}