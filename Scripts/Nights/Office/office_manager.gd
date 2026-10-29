extends Node

onready var office: Node2D = $Office

func on_area2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# This is just a test function for the Button Example
	if event.is_action_pressed("click_left") and office.can_move:
		print("Button Pressed !")
