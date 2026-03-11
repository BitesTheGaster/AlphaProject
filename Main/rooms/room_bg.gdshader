shader_type canvas_item;

uniform sampler2D noise_image : repeat_enable;
uniform float speed = 1;

void fragment() {
	vec3 color = vec3(0.019, 0.007, 0.01);
	
	vec2 uv1 = vec2(UV.x/4.0 + TIME * speed, UV.y/4.0);
	vec2 uv2 = vec2(UV.x/2.0 - TIME * speed, UV.y/2.0);
	vec2 uv3 = vec2(UV.x/4.0*3.0, UV.y/4.0*3.0 + TIME * speed);
	vec2 uv4 = vec2(UV.x, UV.y - TIME * speed);
	
	float noise1 = texture(noise_image, uv1).r;
	float noise2 = texture(noise_image, uv2).r;
	float noise3 = texture(noise_image, uv3).r;
	float noise4 = texture(noise_image, uv4).r;
	
	float alpha = noise1 * noise2 * noise3 * noise4;
	
	COLOR = vec4(color*0.5, alpha);
}