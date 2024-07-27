extends Node2D
class_name AI

export(int, "Red", "Green") var character: int

var char_level: int
var char_pos: int
var empty_room: Array

onready var camera: GameCamera = get_node("/root/Nights/CameraElements")

func _ready():
	# Sets up stuff for _is_room_populated()
	var room_sizes: int = camera.rooms[0].size()
	empty_room.resize(room_sizes)

func has_passed_check() -> bool:
	return true if char_level >= randi()%20+1 else false

func _is_room_populated(room: int) -> bool:
	return false if camera.rooms[room] == empty_room else true

func move_check():
	# Handles whether character moves or not (depending on char_level)
	if has_passed_check():
		char_pos +=1
		move_options()

func move_options():
	pass

func move(from_room: int, to_room: int, check_next_room: bool = false, newstate: int = 1):
	# (1) This function handles character movement from one room to another or character state
	# changes in a room (handled by newstate).
	# (2) You can also have the character check the room it's going to, to see if it's empty, this
	# will determine whether the character enters the room (when false) or not (when true).
	if check_next_room:
		if _is_room_populated(to_room):
			char_pos -= 1
			return
	
	camera.rooms[from_room][character] = 0
	camera.rooms[to_room][character] = newstate
	
	camera.update_rooms([from_room,to_room])
