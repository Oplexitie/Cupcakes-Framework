extends Node
class_name AI

enum State {ABSENT, PRESENT, ALT_1, ALT_2}

@export_enum("Red", "Green") var character: int
@export var camera: Camera

var ai_level: int
var step: int
var current_room: int

func has_passed_check() -> bool:
	# Handles whether character moves or not (depending on char_level)
	return ai_level >= randi_range(1,20)

func _is_room_empty(room: int) -> bool:
	return camera.rooms[room].max() == State.ABSENT

func move_check() -> void:
	if has_passed_check():
		move_options()

func move_options() -> void:
	pass

func move_to(target_room: int, new_state: int = State.PRESENT, move_step: int = 1) -> void:
	# Handles character movement from one room to another
	# And character state changes in a room (handled by new_state)
	step += move_step
	
	camera.rooms[current_room][character] = State.ABSENT
	camera.rooms[target_room][character] = new_state
	
	camera.update_feeds([current_room,target_room])
	current_room = target_room
