extends AI

func move_options():
	match char_pos:
		0:
			move(0,1)
		1:
			move(1,3)
		2:
			# Returns to start position
			move(3,0,-char_pos)

func _char_timer_timeout():
	move_check()
