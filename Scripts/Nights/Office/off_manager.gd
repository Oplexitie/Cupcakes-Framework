extends Node

onready var off_scroll: Node2D = $Office

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	# This is just a test function for the Button Example
	if event.is_action_pressed("click_left") and off_scroll.can_move:
		print('Button Pressed !')
