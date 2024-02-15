extends Sprite

export var pan_speed : float = 5
export var office_clamp : int = 500
# An export made for objects that need a slight offset due to the equirectangular shader (most notably hitboxes for buttons)
# Reminder that objects need to be an Array of an Array to work
# [NodePath, PanOffsetSpeed_x(int), SpeedClamp_x(int), SizeClamp_x(int)]
export var list_offset_corrections : Array = []

# border_distance[0] is for the left border and border_distance[1] is for the right border
var border_distance : Array = [0,0]

func _ready():
	# Get horizontal window size
	var view_size_x : float = get_viewport().size.x
	# The border correcters are made to fix a 1 pixel issue in the code when moving the cursor
	# all the way to the Right of the screen
	var border_correcter_x : float = 1/(OS.get_window_size().x/view_size_x)
	
	# This calculates the area where the cursor needs to be to move the view
	border_distance[0] = view_size_x / 5 # To the Left
	border_distance[1] = view_size_x - (border_distance[0] + border_correcter_x) # To the Right

	# Uses the nodepath within the exported array to use the actual object
	for i in list_offset_corrections:
		i[0] = get_node(i[0])

func _physics_process(delta):
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	var pan_value : float = 0.0
	
	# Checks if the mouse is within one the mouse movement areas, and pans the office if it is
	if mouse_position.x < border_distance[0]:
		pan_value = (border_distance[0] - mouse_position.x) * int(Global.can_move) * pan_speed
	elif mouse_position.x > border_distance[1]:
		pan_value = (border_distance[1] - mouse_position.x) * int(Global.can_move) * pan_speed
	
	# Modifies the position of the office, while clamping it, so the office stays in frame
	position.x= clamp(position.x + clamp(pan_value * delta, -40,40), -office_clamp, office_clamp)

	# Modifies the buttons collision postion, makes it so the button is pressable with the shader
	apply_offset(pan_value, delta)

func apply_offset(pan_value : float, delta : float):
	for i in list_offset_corrections:
		i[0].position.x = clamp(i[0].position.x  + clamp(pan_value/i[1] * delta, -i[2],i[2]), -i[3], i[3])

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	# This is just a test function for the Button Example
	if event.is_action_pressed("click_left"):
		print('Button Pressed !')
