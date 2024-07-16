shader_type canvas_item;

const float PI_TWO = PI * 2.0;

// Can be used to make look up and down mechanic
uniform float pitch;
//
// To get the FOV:
// FOV = viewport_size * ( 1 / ( 360 / full_latitude_or_longitude ) ) / office_image_size
//
// The latitude and longitude of your equirectangular camera
// (in your modeling software of choice) must be identical for this to work properly
//
uniform float fov = 0.32;
// Stretch the screen to your needs after entering your FOV
uniform vec2 stretch = vec2(54.0,27.0);

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

float fit_to_img(float full_lat, float str){
	return(full_lat/str);
}

void fragment(){
	vec2 uv = vec2(PI_TWO,PI) * (SCREEN_UV - 0.5) * fov;
	
	float set = sqrt(uv.x * uv.x + uv.y * uv.y);
	float atset = atan(set), siatset = sin(atset), cosset = cos(atset);
	
	float long = atan(uv.x * siatset , (set * cos(pitch) * cosset - uv.y * sin(pitch) * siatset)) / (PI_TWO) + 0.5;
	float lati = asin((cosset * sin(pitch)) + (uv.y * siatset * cos(pitch)) / set) / PI + 0.5;
	vec2 pers = vec2(long,lati);
	
	vec2 imst;
	imst.x = fit_to_img(180.0, stretch.x);
	imst.y = fit_to_img(90.0, stretch.y);
	
	pers *= imst;
	pers -= (imst/2.0)-0.5;
	
	COLOR = texture(SCREEN_TEXTURE, pers);
}