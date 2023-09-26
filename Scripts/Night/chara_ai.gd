extends Node2D

onready var cam_elements = $"../Camera_Elements"

var char_levels : Array = [20,20]		# Character levels [character1,character2]
var char_pos : Array = [0,0]	# Character positions [character1,character2]

func _ready():
	randomize()

func _char_timer_timeout(extra_arg_0 : int):
	# This function triggers when one of the character timers is done, and handles
	# everything related to character movement
	if (char_levels[extra_arg_0] >= randi()%20+1):
		char_pos[extra_arg_0] +=1
		update_ai_pos(extra_arg_0)

func update_ai_pos(animatronic : int):
	# This function updates the characters position based on the 'char_pos' value
	match animatronic:
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

func ai_move(from_room : int, var to_room : int, character : int, checknextroom : bool = false, newstate : int = 1):
	# (1) This function handles the movement from one room to another or changing the characters
	# state in a room (handled by newstate), while also playing the boot_static animation
	# (2) You can also have the animatronic check the next room it's going to, to see if it's empty
	# if it is, it'll go into the room, otherwise it won't
	
	if(checknextroom == true):
		if(cam_elements.rooms_array[to_room]==[0,0,0,0,0,0]):
			pass
		else:
			char_pos[character]-=1
			return
			
	cam_elements.rooms_array[from_room][character]=0
	cam_elements.rooms_array[to_room][character]=newstate
	if cam_elements.curr_cam ==  from_room or cam_elements.curr_cam ==  to_room:
		cam_elements.tree_state_machine.start("static_boot")
		cam_elements.animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late
	cam_elements.update_rooms([from_room,to_room])
