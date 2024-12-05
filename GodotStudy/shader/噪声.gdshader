shader_type canvas_item;

uniform vec2 u_mouse;

float random_f(in float x) {
    return fract(sin(x)*1e4);
}

float random_vec2(in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float pattern(vec2 st, vec2 v, float t) {
    vec2 p = floor(st+v);
    return step(t, random_vec2(100.+p*.000001)+random_f(p.x)*0.5);
}
vec4 soft_light(vec4 base, vec4 blend){
    vec4 limit = step(0.5, blend);
    return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}
vec4 overlay(vec4 base, vec4 blend){
    vec4 limit = step(0.5, base);
    return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}
vec4 screen(vec4 base, vec4 blend){
    return 1.0 - (1.0 - base) * (1.0 - blend);
}
vec4 linear_burn(vec4 base, vec4 blend){
    return base + blend - 1.0;
}
void fragment() {
	vec2 st = FRAGCOORD.xy * SCREEN_PIXEL_SIZE;
    st.x *= SCREEN_PIXEL_SIZE.y/SCREEN_PIXEL_SIZE.x;

    vec2 grid = vec2(100.0,50.);
    st *= grid;

    vec2 ipos = floor(st);  // integer
    vec2 fpos = fract(st);  // fraction

    vec2 vel = vec2(TIME*2.*max(grid.x,grid.y)); // time
    vel *= vec2(-1.,0.0) * random_f(1.0+ipos.y); // direction

    // Assign a random value base on the integer coord
    vec2 offset = vec2(0.1,0.);

    vec3 color = vec3(0.);
    color.r = pattern(st+offset,vel,0.5+u_mouse.x * SCREEN_PIXEL_SIZE.x);
    color.g = pattern(st,vel,0.5+u_mouse.x * SCREEN_PIXEL_SIZE.x);
    color.b = pattern(st-offset,vel,0.5+u_mouse.x  * SCREEN_PIXEL_SIZE.x);

    // Margins
    color *= step(0.2,fpos.y);
    COLOR = linear_burn(COLOR,vec4(1.0-color,0.1));
}

