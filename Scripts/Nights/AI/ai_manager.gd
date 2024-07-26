extends Node2D

@export_range(0, 20) var red_level: int
@export_range(0, 20) var green_level: int
@export var camera: Camera

func _ready():
	randomize()
	$Red.char_level = red_level
	$Green.char_level = green_level
