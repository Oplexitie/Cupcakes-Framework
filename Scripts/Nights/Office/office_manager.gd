extends Node2D

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	# This is just a test function for the Button Example
	if event.is_action_pressed("click_left") and Scroll.can_move:
		print('Button Pressed !')
