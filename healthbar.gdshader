shader_type canvas_item;

uniform float health;

void fragment() {
	float x = abs(UV.x * 2.0 - 1.0);
	float y = abs(UV.y * 2.0 - 1.0);
	x *= .8;
	float a = 1.0;
	//y -= .5 * x * x;
	a *= 1.0 - smoothstep(.5, .55, y);
	a *= 1.0 - smoothstep(health, health + .005, x);
	COLOR = vec4(0, 9999, 9999, a);
	
}
