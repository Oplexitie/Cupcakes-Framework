extends Sprite

var border_distance : Vector2
var mouse_position : Vector2
var pan_value : float
var can_move : bool = true
var view_size_x : float

func _ready():
	# get_viewport().size.x seems to be off by -1 for some reason
	view_size_x = get_viewport().size.x - 1
	
	# Calculates the area where the cursor needs to be, to move the camera
	border_distance.x = view_size_x / 5
	border_distance.y = view_size_x - border_distance.x

func _physics_process(delta):
	mouse_position = get_viewport().get_mouse_position()
	
	# Checks if the mouse is within one the mouse movement areas, and pans the office if is
	if mouse_position.x < border_distance.x:
		pan_value = (border_distance.x - mouse_position.x) * int(can_move) * 5
	elif mouse_position.x > border_distance.y:
		pan_value = (border_distance.y - mouse_position.x) * int(can_move) * 5
	else:
		pan_value = 0
	
	# Modifies the position of the office, while clamping it, so the office stays in frame
	position.x = clamp(position.x + clamp(pan_value * delta, -40,40), -960,960)
