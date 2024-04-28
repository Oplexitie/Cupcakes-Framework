extends Sprite2D

class_name OfficeScroll

@export var scroll_speed : float = 3
@export var office_clamp : int = 650
# An export made for objects hitboxes that need an offset due to the equirectangular shader
# Reminder that for each object there needs to be an Array of an Array to work
# [NodePath, EdgeSpeed_x(int), SpeedClamp_left(int), SizeClamp_right(int)]
@export var item_offsets : Array = []

var scroll_area : Dictionary = { "Left": 0, "Right": 0 }
var can_move = true

func _ready():
	var view_size_x : float = get_viewport().content_scale_size.x
	# Border correcter is made to fix a 1 pixel issue all the way to the right of the screen
	var border_correcter_x : float = 1/(get_viewport().size.x/view_size_x)
	
	# This calculates the scroll area on both sides of the screen
	scroll_area["Left"] = view_size_x / 3
	scroll_area["Right"] = view_size_x - (scroll_area["Left"] + border_correcter_x)
	
	for i in item_offsets:
		i[0] = get_node(i[0])

func _physics_process(delta):
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	var scroll_amount : float
	
	if can_move:
		# Checks if the mouse is within one of the scroll areas, and scrolls if it is
		if mouse_position.x < scroll_area["Left"]:
			scroll_amount = (scroll_area["Left"] - mouse_position.x) * scroll_speed
		elif mouse_position.x > scroll_area["Right"]:
			scroll_amount = (scroll_area["Right"] - mouse_position.x) * scroll_speed
	
	# Clamps the position so the office doesn't leave the frame
	position.x = clamp(position.x + scroll_amount * delta, -office_clamp, office_clamp)
	apply_offset(scroll_amount, delta)

func apply_offset(scroll_amount : float, delta : float):
	# Modifies the buttons collision postion, makes it so the button is pressable with the shader
	for i in item_offsets:
		i[0].position.x = clamp((position.x - i[1] + i[0].position.x/2) + scroll_amount * delta, i[2], i[3])
