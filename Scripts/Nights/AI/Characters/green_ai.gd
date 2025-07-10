extends AI

enum {ROOM_01, ROOM_02, ROOM_03, ROOM_04}

func move_options() -> void:
	match step:
		0:
			move_to(ROOM_02)
		1:
			move_to(ROOM_04)
		2:
			# Returns to start position
			move_to(ROOM_01,State.PRESENT,-step)
