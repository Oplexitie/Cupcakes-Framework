extends Node2D

@export var camera : CameraManager
@export var cam_feed : CameraUpdater

var char_levels : Array = [20,20]		# Character difficulty levels [character1,character2]
var char_pos : Array = [0,0]	# Character positions [character1,character2]

func _ready():
	randomize()

func update_ai_pos(character : int):
	# This function updates the characters position based on the 'char_pos' value
	match character:
		0:
			match char_pos[0]:
				0:
					ai_move(2,0,0)
				1:
					ai_move(0,1,0)
				2:
					ai_move(1,2,0)
				3: 
					char_pos[0] = 0
					update_ai_pos(0)
		1:
			match char_pos[1]:
				0:
					ai_move(3,0,1)
				1:
					ai_move(0,1,1)
				2:
					ai_move(1,3,1)
				3:
					char_pos[1] = 0
					update_ai_pos(1)

func ai_move(from_room : int, to_room : int, character : int, checknextroom : bool = false, newstate : int = 1):
	# (1) This function handles character movement from one room to another or changing the
	# characters state in a room (handled by newstate).
	# (2) You can also have the character check the next room it's going to, to see if it's empty,
	# this will determine whether the character enters the room (when false) or not (when true).
	if checknextroom:
		if cam_feed.room_visitors[to_room]==[0,0,0,0,0,0]:
			pass
		else:
			char_pos[character]-=1
			return
			
	cam_feed.room_visitors[from_room][character]=0
	cam_feed.room_visitors[to_room][character]=newstate
	if camera.current_feed == from_room or camera.current_feed == to_room:
		camera.tree_state_machine.start("static_boot")
		camera.animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late
	cam_feed.update_rooms([from_room,to_room])

func _char_timer_timeout(character : int):
	# Triggers when one of the character timers is done, and handles character movement/difficutly
	if char_levels[character] >= randi()%20+1:
		char_pos[character] +=1
		update_ai_pos(character)
