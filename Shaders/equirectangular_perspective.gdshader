shader_type canvas_item;

// To get the right FOV:
// FOV = viewport_size * ( 1 / ( 360 / full_latitude_or_longitude ) ) / office_image_size
//
// The latitude and longitude of your equirectangular camera
// (in your modeling software of choice) must be identical for this to work properly

const float PI = 3.14159265358979;
const float PI_TWO = PI * 2.0;
uniform float fov = 0.32;
uniform vec2 stretch = vec2(54.0,27.0); // Stretch the screen to your needs after entering your FOV

void fragment(){
	vec2 uv = (SCREEN_UV - 0.5) * vec2(PI_TWO,PI) * fov;
	
	float set = sqrt(uv.x * uv.x + uv.y * uv.y);
	float aset = atan(set), saset = sin(aset), caset = cos(aset);
	
	float long = atan((uv.x * saset) / (set * caset));
	float lati = asin((uv.y * saset) / set);
	
	vec2 pers = vec2(long,lati) / PI + 0.5;
	vec2 imst = 90.0 / stretch;
	
	pers *= imst;
	pers -= (imst / 2.0) - 0.5;
	
	//This is for GLES2
	COLOR = texture(SCREEN_TEXTURE, pers);
	
	//This is for GLES3
	//COLOR.rgb = textureLod(SCREEN_TEXTURE, pers, 0.0).rgb;
}