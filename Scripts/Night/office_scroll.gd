extends Sprite

export var office_clamp : int
export var pan_speed_x : float
export var pan_speed_y : float
# An export made for objects that need a slight offset due to the equirectangular shader (most notably hitboxes for buttons)
# Reminder that objects need to be an Array of an Array to work
# [NodePath, PanOffsetSpeed_x(int), SpeedClamp_x(int), SizeClamp_x(int)]
export var list_offset_corrections : Array
export var shader_path : NodePath

# border_distance[0] is horiztontal and border_distance[1] is vertical
var border_distance : Array = [Vector2.ZERO, Vector2.ZERO]
var pan_value : Vector2
var pan_pos_y : float = 0.0

onready var shader_stuff : ColorRect = get_node(shader_path)

func _ready():
	# get the horizontal size of the window
	var view_size_x = get_viewport().size.x
	var view_size_y = get_viewport().size.y
	
	# This calculates the area where the cursor needs to be to move pan the view to the left.
	border_distance[0].x = view_size_x / 5
	
	# This calculates the area where the cursor needs to be to move pan the view to the right.
	# The border correcter is made to (kinda) fix the fact that the cursor can't go all the
	# way to the right by 1 pixel.
	var border_correcter = 1/(1920/view_size_x)
	border_distance[0].y = view_size_x - (border_distance[0].x + border_correcter)
	
	
	border_distance[1].x = view_size_y / 5
	
	border_correcter = 1/(1080/view_size_y)
	border_distance[1].y = view_size_y - (border_distance[1].x + border_correcter)

	# Uses the nodepath within the exported array to use the actual object
	for i in list_offset_corrections:
		i[0] = get_node(i[0])

func _physics_process(delta):
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	# Checks if the mouse is within one the mouse movement areas, and pans the office if is
	if mouse_position.x < border_distance[0].x:
		pan_value.x = (border_distance[0].x - mouse_position.x) * int(Global.can_move) * pan_speed_x
	elif mouse_position.x > border_distance[0].y:
		pan_value.x = (border_distance[0].y - mouse_position.x) * int(Global.can_move) * pan_speed_x
	else:
		pan_value.x = 0
	
	if mouse_position.y < border_distance[1].x:
		pan_value.y = (border_distance[1].x - mouse_position.y) * int(Global.can_move) * pan_speed_y
	elif mouse_position.y > border_distance[1].y:
		pan_value.y = (border_distance[1].y - mouse_position.y) * int(Global.can_move) * pan_speed_y
	else:
		pan_value.y = 0
	
	# Modifies the position of the office, while clamping it, so the office stays in frame
	position.x= clamp(position.x + clamp(pan_value.x * delta, -40,40), -office_clamp, office_clamp)
	
	# Modifies the y post of the perspective shader, while clamping it, so the office stays in frame
	pan_pos_y = clamp(pan_pos_y + clamp((pan_value.y/270) * delta,-0.4,0.4),-0.3,0.3)
	shader_stuff.material.set_shader_param("yaxis",pan_pos_y)
	
	# Modifies the buttons collision postion, makes it so the button is pressable with the shader
	apply_offset(delta)

func apply_offset(delta):
	for i in list_offset_corrections:
		i[0].position.x = clamp(i[0].position.x  + clamp(pan_value.x/i[1] * delta, -i[2],i[2]), -i[3], i[3])
		i[0].position.y = clamp(i[0].position.y  + clamp((pan_value.y)/i[4] * delta, -i[5],i[5]), -i[6], i[6])

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click_left"):
		print('Button Pressed !')
