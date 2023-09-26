extends Node2D

onready var animtree = $AnimationTree
onready var tree_state_machine = animtree["parameters/StaticState/playback"]

onready var cam_rooms = $Cam_Rooms
onready var cam_buttons = $Cam_Buttons

var curr_cam : int = 0

# rooms_array = [room1[character1,character2],room2[empty,empty]]
# 0=empty 1=character other=special_character_pose
var rooms_array : Array = [[1,1],[0,0],[0,0],[0,0]]
var cam_room_array : Array = []
var cam_button_array : Array = []

func _ready():
	# Adds the camera images and buttons into seperate arrays so they can be synced
	# up in the '_on_click_cam' function
	for i in cam_rooms.get_children():
		cam_room_array.append(i)
	for i in cam_buttons.get_children():
		cam_button_array.append(i)
	cam_button_array[0].disabled = true
	update_rooms([0,1,2,3])

func _on_click_cam(extra_arg_0 : int):
	# This function handles switching cameras, while preventing the player from
	# spamming the same camera and getting the same switching animation
	if curr_cam != extra_arg_0:
		tree_state_machine.start("static_boot")
		animtree.advance(0)		# this fixes a problem where the static plays 1 frame too late
		
		cam_room_array[curr_cam].visible = false
		cam_button_array[curr_cam].disabled = false
		
		cam_room_array[extra_arg_0].visible = true
		cam_button_array[extra_arg_0].disabled = true
		
		curr_cam = extra_arg_0

func update_rooms(rooms_to_update : Array):
	# (1) This function handles the room states based on the room array's, that's modified,
	# by the 'ai_move' function
	# (2) If you want to have an animated sprite you'll need to use an AnimationPlayer
	for i in rooms_to_update:
		match i:
			0:
				match rooms_array[0]:
					[0,0]:
						cam_room_array[0].frame = 3
					[1,0]:
						cam_room_array[0].frame = 2
					[0,1]:
						cam_room_array[0].frame = 1
					[1,1]:
						cam_room_array[0].frame = 0
			1:
				match rooms_array[1]:
					[0,0]:
						cam_room_array[1].frame = 3
					[1,0]:
						cam_room_array[1].frame = 2
					[0,1]:
						cam_room_array[1].frame = 1
					[1,1]:
						cam_room_array[1].frame = 0
			2:
				match rooms_array[2]:
					[0,0]:
						cam_room_array[2].frame = 1
					[1,0]:
						cam_room_array[2].frame = 0
			3:
				match rooms_array[3]:
					[0,0]:
						cam_room_array[3].frame = 1
					[0,1]:
						cam_room_array[3].frame = 0
