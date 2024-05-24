extends Node2D

# Each room has an array containing all of characters postitions, each index corresponds to a character
# 0 = Empty ; 1 = Character in Room ; Other = Possible special poses for Characters in Room
var room_visitors : Array = [[1,1],[0,0],[0,0],[0,0]]

onready var camera : Node2D = get_parent()

func update_rooms(rooms_to_update : Array):
	# This handles the camera feeds based on the character positions
	for i in rooms_to_update:
		match i:
			0:
				match room_visitors[0]:
					[0,0]:
						camera.all_feeds[0].frame = 3
					[1,0]:
						camera.all_feeds[0].frame = 2
					[0,1]:
						camera.all_feeds[0].frame = 1
					[1,1]:
						camera.all_feeds[0].frame = 0
			1:
				match room_visitors[1]:
					[0,0]:
						camera.all_feeds[1].frame = 3
					[1,0]:
						camera.all_feeds[1].frame = 2
					[0,1]:
						camera.all_feeds[1].frame = 1
					[1,1]:
						camera.all_feeds[1].frame = 0
			2:
				match room_visitors[2]:
					[0,0]:
						camera.all_feeds[2].frame = 1
					[1,0]:
						camera.all_feeds[2].frame = 0
			3:
				match room_visitors[3]:
					[0,0]:
						camera.all_feeds[3].frame = 1
					[0,1]:
						camera.all_feeds[3].frame = 0
		
		if camera.current_feed == i:
			camera.tree_state_machine.start("static_boot")
			camera.animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late
