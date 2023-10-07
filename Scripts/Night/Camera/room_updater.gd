extends Node2D

# room_content_array = [room1[character1,character2],room2[empty,empty]]
# 0=empty 1=character other=special_character_pose
var room_content_array : Array = [[1,1],[0,0],[0,0],[0,0]]

onready var cam_elements : Node2D = get_parent()

func update_rooms(rooms_to_update : Array):
	# (1) This function handles the room states based on the room array's, that's modified,
	# by the 'ai_move' function
	# (2) If you want to have an animated sprite you'll need to use an AnimationPlayer
	for i in rooms_to_update:
		match i:
			0:
				match room_content_array[0]:
					[0,0]:
						cam_elements.cam_rvisual_array[0].frame = 3
					[1,0]:
						cam_elements.cam_rvisual_array[0].frame = 2
					[0,1]:
						cam_elements.cam_rvisual_array[0].frame = 1
					[1,1]:
						cam_elements.cam_rvisual_array[0].frame = 0
			1:
				match room_content_array[1]:
					[0,0]:
						cam_elements.cam_rvisual_array[1].frame = 3
					[1,0]:
						cam_elements.cam_rvisual_array[1].frame = 2
					[0,1]:
						cam_elements.cam_rvisual_array[1].frame = 1
					[1,1]:
						cam_elements.cam_rvisual_array[1].frame = 0
			2:
				match room_content_array[2]:
					[0,0]:
						cam_elements.cam_rvisual_array[2].frame = 1
					[1,0]:
						cam_elements.cam_rvisual_array[2].frame = 0
			3:
				match room_content_array[3]:
					[0,0]:
						cam_elements.cam_rvisual_array[3].frame = 1
					[0,1]:
						cam_elements.cam_rvisual_array[3].frame = 0
