extends Node2D
class_name AI

@export_enum("Red", "Green") var character: int
@export var camera: Camera

var char_level: int
var char_pos: int

func has_passed_check() -> bool:
	return true if char_level >= randi_range(0,20) else false

func _is_room_populated(room: int) -> bool:
	return false if camera.rooms[room].max() == 0 else true

func move_check():
	# Handles whether character moves or not (depending on char_level)
	if has_passed_check():
		char_pos +=1
		move_options()

func move_options():
	pass

func move(from_room: int, to_room: int, check_next_room: bool = false, new_state: int = 1):
	# (1) This function handles character movement from one room to another or character state
	# changes in a room (handled by new_state).
	# (2) You can also have the character check the room it's going to, to see if it's empty, this
	# will determine whether the character enters the room (when false) or not (when true).
	if check_next_room:
		if _is_room_populated(to_room):
			char_pos -= 1
			return
	
	camera.rooms[from_room][character] = 0
	camera.rooms[to_room][character] = new_state
	
	camera.update_feeds([from_room,to_room])
