shader_type canvas_item;

uniform bool blink = false;
uniform float bright_amount = .3;

uniform bool darken = false;
uniform float darken_amount = .3;

uniform bool blue = false;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if (blink == true) {
		c.rgb += vec3(bright_amount);
	}
	if (darken == true) {
		c.rgb -= vec3(darken_amount);
	}
	if (blue == true) {
		c.rgb -= vec3(0.25, 0.25, 0.1);
	}
	COLOR = c;
}
