shader_type canvas_item;

const float PI_TWO = PI * 2.0;
const float HALF_PI = PI / 2.0;

uniform float fov = 0.37;
uniform float x_stretch = 54.0;
uniform float y_stretch = 30.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

float fit_to_img(float full_lat, float str){
	return(full_lat/str);
}

void fragment(){
	vec2 uv = SCREEN_UV;
	
	vec2 pan = (uv * 2.0 - 1.0) * fov * vec2(PI, HALF_PI);
	float set = sqrt(pan.x * pan.x + pan.y * pan.y); 
	float long = atan((pan.x * sin(atan(set)) ) / (set * cos(atan(set)) )) / PI_TWO + 0.5;	
	float lati = asin((pan.y * sin(atan(set)) ) / set) / PI + 0.5;
	vec2 pers = vec2(long,lati);
	
	vec2 imst;
	imst.x = fit_to_img(180.0, x_stretch);
	imst.y = fit_to_img(90.0, y_stretch);
	
	pers *= imst;
	pers -= (imst/2.0)-0.5;
	
	COLOR = texture(SCREEN_TEXTURE, pers);
}