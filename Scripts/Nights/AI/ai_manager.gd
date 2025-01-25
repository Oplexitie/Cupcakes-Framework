extends Node2D

@export_range(0, 20) var red_level: int
@export_range(0, 20) var green_level: int

func _ready() -> void:
	randomize() # Sets new RNG seed
	_initialize_char_levels()

func _initialize_char_levels() -> void:
	$Red.char_level = red_level
	$Green.char_level = green_level
