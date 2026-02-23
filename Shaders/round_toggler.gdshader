shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform float have_effect : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec2 grid = vec2(16,5);
	vec3 efeito = vec3(0.21,0.217,0.055);
	float efeito_alpha = texture(noise,floor((UV +vec2(TIME,0)*0.2)*grid)/grid).r;
	COLOR.rgb += efeito*efeito_alpha*have_effect ;
}