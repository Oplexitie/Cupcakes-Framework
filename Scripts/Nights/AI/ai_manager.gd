extends Node2D

export(int, 0, 20) var red_level: int
export(int, 0, 20) var green_level: int
export(String) var camera_path

func _ready():
	randomize()
	$Red.char_level = red_level
	$Green.char_level = green_level
