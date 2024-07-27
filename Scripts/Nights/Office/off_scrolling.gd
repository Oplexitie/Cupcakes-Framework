extends Node2D

const SCROLL_SMOOTHING: int = 12 # Lower for smoother scrolling
const SCROLL_SPEED: float = 0.07 # Lower for faster scrolling
const SCROLL_CLAMP: int = 650 # Clamps office scrolling on both sides

# An export made for objects hitboxes that need an offset due to the equirectangular shader
# Reminder that for each object there needs to be an Array of an Array to work
# [NodePath, EdgeSpeed_x(int), SpeedClamp_left(int), SizeClamp_right(int)]
export var item_offsets: Array = []

var scroll_area_left: float
var scroll_area_right: float
var scroll_amount: float = 0
var can_move: bool = true

func _ready():
	var view_size_x: float = get_viewport().size.x
	# Made to fix a 1 pixel issue at the right of the screen when view_size_x isn't a whole number
	var border_correcter_x: float = 1 / (OS.get_window_size().x / view_size_x)
	
	# This calculates the scroll area on both sides of the screen
	scroll_area_left = view_size_x / 3
	scroll_area_right = view_size_x - (scroll_area_left + border_correcter_x)
	
	for i in item_offsets:
		i[0] = get_node(i[0])

func _physics_process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if can_move:
		# Checks if the mouse is within one of the scroll areas, and scrolls if it is
		if mouse_position.x < scroll_area_left:
			scroll_amount += (scroll_area_left - mouse_position.x) * SCROLL_SPEED
		elif mouse_position.x > scroll_area_right:
			scroll_amount += (scroll_area_right - mouse_position.x) * SCROLL_SPEED
	
	scroll_amount = clamp(scroll_amount, -SCROLL_CLAMP, SCROLL_CLAMP)
	
	# Clamps the position so the office doesn't leave the frame
	position.x = lerp(position.x, scroll_amount, SCROLL_SMOOTHING * delta)
	apply_offset(scroll_amount, delta)

func apply_offset(scroll_modifier: float, delta: float):
	# Modifies the buttons collision postion, makes it so the button is pressable with the shader
	for i in item_offsets:
		i[0].position.x = clamp((position.x - i[1] + i[0].position.x/2) + scroll_modifier * delta, i[2], i[3])
