extends Sprite2D

const SCROLL_SMOOTHING: int = 12 # Lower for smoother scrolling
const SCROLL_SPEED: float = 0.07 # Lower for faster scrolling
const SCROLL_CLAMP: int = 650 # Clamps office scrolling on both sides

var scroll_area_left: float
var scroll_area_right: float
var scroll_amount: float = 0
var can_move: bool = true
var trigger_offsets: Array[Array]

func _ready() -> void:
	_initialize_scroll_areas(get_viewport())
	_initialize_triggers()

func _physics_process(delta: float) -> void:
	_handle_move(delta)
	_handle_trigger_offsets(scroll_amount, delta)

func _initialize_scroll_areas(viewport: Viewport) -> void:
	var view_size_x: float = viewport.content_scale_size.x
	# Fixes a 1 pixel issue at the right of the screen when view_size_x isn't a whole number
	var border_correcter_x: float = 1 / (viewport.size.x / view_size_x)
	
	# Calculates the size of the scroll area on both sides of the screen
	scroll_area_left = view_size_x / 3
	scroll_area_right = view_size_x - (scroll_area_left + border_correcter_x)

func _initialize_triggers() -> void:
	# Sets up trigger hitboxes that need an offset due to the equirectangular shader
	# [Area2D, XSpeed(int), LeftClamp(int), RightClamp(int)]
	for i in get_children():
		var meta_array: Array = [i.get_node("Area2D")]
		for y in i.get_meta_list(): meta_array.append_array([i.get_meta(y)])
		
		trigger_offsets.append(meta_array)

func _handle_move(delta: float) -> void:
	if can_move:
		var mouse_position: Vector2 = get_global_mouse_position()
		# Checks if the mouse is within one of the scroll areas, and scrolls if it is
		if mouse_position.x < scroll_area_left:
			scroll_amount += (scroll_area_left - mouse_position.x) * SCROLL_SPEED
		elif mouse_position.x > scroll_area_right:
			scroll_amount += (scroll_area_right - mouse_position.x) * SCROLL_SPEED
	
	# Clamps the position so the office doesn't leave the frame
	scroll_amount = clamp(scroll_amount, -SCROLL_CLAMP, SCROLL_CLAMP)
	position.x = lerp(position.x, scroll_amount, SCROLL_SMOOTHING * delta)

func _handle_trigger_offsets(scroll_modifier: float, delta: float) -> void:
	# Modifies the buttons collision postion, makes it so the button is pressable with the shader
	for i in trigger_offsets:
		i[0].position.x = clamp((position.x - i[1] + i[0].position.x/2) + scroll_modifier * delta, i[2], i[3])
