extends Node2D
class_name AI

@export_enum("Red", "Green") var character: int
@export var camera: Camera

var char_level: int
var char_pos: int

func has_passed_check() -> bool:
	# Handles whether character moves or not (depending on char_level)
	return char_level >= randi_range(0,20)

func _is_room_empty(room: int) -> bool:
	return camera.rooms[room].max() == 0

func move_check():
	if has_passed_check():
		move_options()

func move_options():
	pass

func move(from_room: int, to_room: int, move_step: int = 1, new_state: int = 1):
	# Handles character movement from one room to another
	# And character state changes in a room (handled by new_state).
	char_pos += move_step
	
	camera.rooms[from_room][character] = 0
	camera.rooms[to_room][character] = new_state
	
	camera.update_feeds([from_room,to_room])
