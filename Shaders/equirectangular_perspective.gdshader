shader_type canvas_item;

const float PI = 3.14159265358979;
const float PI_TWO = PI * 2.0;

uniform float yaxis;   
uniform vec2 fov = vec2(0.37,0.37);
uniform vec2 stretch = vec2(58.0, 54.0);

float fit_to_img(float full_lat, float str){
	return(full_lat/str);
}

void fragment(){
	vec2 uv = vec2(PI_TWO,PI) * (SCREEN_UV - 0.5) * fov;
	
	float set = sqrt(uv.x * uv.x + uv.y * uv.y);
	float atset = atan(set), siatset = sin(atset), cosset = cos(atset);
	
	float long = atan(uv.x * siatset , (set * cos(yaxis) * cosset - uv.y * sin(yaxis) * siatset)) / (PI_TWO) + 0.5;
	float lati = asin((cosset * sin(yaxis)) + (uv.y * siatset * cos(yaxis)) / set) / PI + 0.5;
	vec2 pers = vec2(long,lati);
	
	vec2 imst;
	imst.x = fit_to_img(180.0, stretch.x);
	imst.y = fit_to_img(90.0, stretch.y);
	
	pers *= imst;
	pers -= (imst/2.0)-0.5;
	
	//This is for GLES2
	COLOR = texture(SCREEN_TEXTURE, pers);
	
	//This is for GLES3
	//COLOR.rgb = textureLod(SCREEN_TEXTURE, pers, 0.0).rgb;
}