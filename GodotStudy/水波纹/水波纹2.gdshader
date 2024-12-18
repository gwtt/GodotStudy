shader_type canvas_item;

// 第一层波纹中心
uniform vec2 center1 = vec2(0.5, 0.5);
// 第二层波纹中心
uniform vec2 center2 = vec2(0.4, 0.4);
// 时间变量，用于控制波纹动画
uniform float time = 0.0;
// 噪声纹理
uniform sampler2D noise_texture;

void fragment() {
    // 采样噪声纹理
    vec2 noise_uv = UV;
    vec4 noise_value = texture(noise_texture, noise_uv);

    // 第一层波纹
    float dist1 = length(UV - center1);
    float wave_freq1 = 10.0 + (noise_value.r - 0.5) * 10.0;
    float wave1 = sin(dist1 * wave_freq1 - time * 5.0);
    float alpha1 = abs(wave1) * 0.2 * (0.3 + 0.7 * noise_value.g);

    // 第二层波纹
    float dist2 = length(UV - center2);
    float wave_freq2 = 15.0 + (noise_value.r - 0.5) * 10.0;
    float wave2 = sin(dist2 * wave_freq2 - time * 3.0);
    float alpha2 = abs(wave2) * 0.1 * (0.4 + 0.6 * noise_value.b);

    // 合并两层波纹的透明度
    float alpha = (alpha1 + alpha2) * 0.5;

    // 根据波纹的值设置颜色，这里得到白色波纹
    COLOR = vec4(1.0, 1.0, 1.0, alpha);
}