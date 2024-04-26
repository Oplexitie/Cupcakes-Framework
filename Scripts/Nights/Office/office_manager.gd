extends Node2D

@onready var off_scroll : Node2D = $Office

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	# This is just a test function for the Button Example
	if event.is_action_pressed("click_left") and off_scroll.can_move == true:
		print('Button Pressed !')
