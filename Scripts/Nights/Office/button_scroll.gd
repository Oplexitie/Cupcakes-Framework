extends Node2D

@export var horiz_speed: int
@export var left_clamp: int
@export var right_clamp: int

@onready var button_area: Area2D = $Area2D

func _physics_process(delta: float) -> void:
	_handle_move(delta)

func _handle_move(delta) -> void:
	# Moves the button hitboxes that need an offset due to the equirectangular shader
	var scroll_pos: float = ((global_position.x - position.x) - horiz_speed) + delta
	button_area.position.x = clamp(scroll_pos, left_clamp, right_clamp)
