shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);
uniform float amplitude : hint_range(0.0, 0.1) = 0.05;
uniform float frequency : hint_range(1.0, 20.0) = 10.0;
uniform float speed : hint_range(0.1, 5.0) = 2.0; // 波纹传播速度

void fragment() {
    // 计算当前像素到中心点的距离
    float dist = distance(SCREEN_UV, center);
    
    // 创建基于时间的波纹效果
    float wave = sin((dist * frequency) - (TIME * speed));
    
    // 计算偏移量
    vec2 offset = normalize(SCREEN_UV - center) * (wave * amplitude);
    
    // 使用偏移后的坐标采样屏幕纹理
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + offset);
}