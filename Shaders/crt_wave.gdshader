shader_type canvas_item;

uniform float roll_speed = 8.0;
uniform float roll_size : hint_range(0.0, 100.0) = 15.0;
uniform float roll_variation : hint_range(0.1, 5.0) = 1.8;
uniform float distort_intensity : hint_range(0.0, 0.2) = 0.05;

uniform float noise_opacity : hint_range(0.0, 1.0) = 0.4;

void fragment()
{
	vec2 uv = SCREEN_UV;
	vec2 text_uv = uv;
	vec2 roll_uv = vec2(0.0);
	float time = TIME;
	
	// Create the rolling effect. We need roll_line a bit later to make the white line effect.
	float roll_line = 0.0;
	roll_line = smoothstep(0.3, 0.9, sin(uv.y * roll_size - (time * roll_speed) ) );
	roll_line *= roll_line * smoothstep(0.3, 0.9, sin(uv.y * roll_size * roll_variation - (time * roll_speed * roll_variation) ) );
	roll_uv = vec2(( roll_line * distort_intensity * (1.0-UV.x)), 0.0);
	
	// Use text_uv and roll_uv in text so it can later applied to the color
	vec4 text;
	text.r = texture(SCREEN_TEXTURE, text_uv + roll_uv * 0.8).r;
	text.g = texture(SCREEN_TEXTURE, text_uv + roll_uv * 1.2).g;
	text.b = texture(SCREEN_TEXTURE, text_uv + roll_uv).b;
	text.a = 1.0;
	
	// Generate the white line pattern that is very stretched horizontally
	float noise = smoothstep(0.4, 0.5, 1.0);
	roll_line *= noise;
	text.rgb = clamp(mix(text.rgb, text.rgb + roll_line, noise_opacity), vec3(0.0), vec3(1.0));
	
	COLOR = text;
}