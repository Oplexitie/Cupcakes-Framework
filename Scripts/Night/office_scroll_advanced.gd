extends Sprite

export var pan_speed : Vector2
export var office_clamp : Vector2
# An export made for objects that need a slight offset due to the equirectangular shader (most notably hitboxes for buttons)
# Reminder that objects need to be an Array of an Array to work
# [NodePath, PanOffsetSpeed_x(int), SpeedClamp_x(int), SizeClamp_x(int),
#            PanOffsetSpeed_y(int), SpeedClamp_y(int), SizeClamp_y(int)]
export var list_offset_corrections : Array
export var shader_path : NodePath

# border_distance[0] is for the x axis and border_distance[1] is for the y axis
# The arrays inside correspond to left and right for border_distance[0]
# And up and down for border_distance[1]
var border_distance : Array = [[0,0], [0,0]]
var pan_pos_y : float = 0.0

onready var shader_stuff : ColorRect = get_node(shader_path)

func _ready():
	# Get vertical and horizontal window size
	var view_size : Vector2 = Vector2(get_viewport().size.x, get_viewport().size.y)
	# The border correcters are made to fix a 1 pixel issue in the code when moving the cursor
	# all the way to the Right and the Bottom of the screen
	var border_correcter_x : float = 1/(1920/view_size.x)
	var border_correcter_y : float = 1/(1080/view_size.y)
	
	# This calculates the area where the cursor needs to be to move the view
	border_distance[0][0] = view_size.x / 5 # To the Left
	border_distance[0][1] = view_size.x - (border_distance[0][0] + border_correcter_x) # To the Right
	border_distance[1][0] = view_size.y / 5 # To the Top
	border_distance[1][1] = view_size.y - (border_distance[1][0] + border_correcter_y) # To the Bottom

	# Uses the nodepath within the exported array to use the actual object
	for i in list_offset_corrections:
		i[0] = get_node(i[0])

func _physics_process(delta):
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	var pan_value : Vector2 = Vector2.ZERO
	
	# Checks if the mouse is within one the mouse movement areas, and pans the office if it is
	if mouse_position.x < border_distance[0][0]:
		pan_value.x = (border_distance[0][0] - mouse_position.x) * int(Global.can_move) * pan_speed.x
	elif mouse_position.x > border_distance[0][1]:
		pan_value.x = (border_distance[0][1] - mouse_position.x) * int(Global.can_move) * pan_speed.x
	
	if mouse_position.y < border_distance[1][0]:
		pan_value.y = (border_distance[1][0] - mouse_position.y) * int(Global.can_move) * pan_speed.y
	elif mouse_position.y > border_distance[1][1]:
		pan_value.y = (border_distance[1][1] - mouse_position.y) * int(Global.can_move) * pan_speed.y
	
	# Modifies the position of the office, while clamping it, so the office stays in frame
	position.x= clamp(position.x + clamp(pan_value.x * delta, -40,40), -office_clamp.x, office_clamp.x)
	
	# Modifies the y post of the perspective shader, while clamping it, so the office stays in frame
	pan_pos_y = clamp(pan_pos_y + clamp((pan_value.y/270) * delta, -0.4, 0.4), -office_clamp.y, office_clamp.y)
	shader_stuff.material.set_shader_param("yaxis",pan_pos_y)
	
	# Modifies the buttons collision postion, makes it so the button is pressable with the shader
	apply_offset(pan_value, delta)

func apply_offset(pan_value : Vector2, delta : float):
	for i in list_offset_corrections:
		i[0].position.x = clamp(i[0].position.x  + clamp(pan_value.x/i[1] * delta, -i[2],i[2]), -i[3], i[3])
		i[0].position.y = clamp(i[0].position.y  + clamp((pan_value.y)/i[4] * delta, -i[5],i[5]), -i[6], i[6])

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	# This is just a test function for the Button Example
	if event.is_action_pressed("click_left"):
		print('Button Pressed !')
