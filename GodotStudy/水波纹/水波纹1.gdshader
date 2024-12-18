shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform sampler2D noise_texture;
uniform vec2 stone_position = vec2(0.5); // 石头的中心位置
uniform float stone_radius = 0.1; // 石头的半径，用于确定水波纹的起始位置
uniform float wave_speed = 0.5; // 水波纹扩散的速度
uniform float wave_intensity = 0.1; // 水波纹的强度

void fragment() {
    // 获取像素的UV坐标
    vec2 uv = UV;
    
    // 计算从石头中心点的距离
    float distance_from_stone = length(uv - stone_position);
    
    // 计算水波纹的半径，随时间增加
    float wave_radius = stone_radius + wave_speed * sin(TIME);
    
    // 计算水波纹的透明度，使用smoothstep函数来创建渐变效果
    float wave_opacity = smoothstep(wave_radius - wave_intensity, wave_radius + wave_intensity, distance_from_stone);
    
    // 使用噪声函数来模拟水波纹的不规则性
    float noise = texture(noise_texture, (uv - stone_position) * 10.0 + TIME).r;
    noise = noise * 0.5 + 0.5; // 调整噪声范围到0.5到1.0之间
    
    // 根据噪声和透明度调整水波纹的最终透明度
    float final_opacity = noise * wave_opacity;
    
    // 如果最终透明度小于某个阈值，则设置为完全透明
    final_opacity = final_opacity > 0.05 ? final_opacity : 0.0;
    
    // 设置颜色为白色，并根据最终透明度调整颜色
    vec4 color = vec4(1.0, 1.0, 1.0, final_opacity);
    
    // 输出颜色
    COLOR = color;
}