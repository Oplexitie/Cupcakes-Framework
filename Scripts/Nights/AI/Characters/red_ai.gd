extends AI

func move_options() -> void:
	match char_pos:
		0:
			if _is_room_empty(1):
				move(0,1)
		1:
			move(1,2)
		2: 
			# Returns to start position
			move(2,0,-char_pos)
