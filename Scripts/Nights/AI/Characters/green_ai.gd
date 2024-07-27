extends AI

func move_options():
	match char_pos:
		0:
			move(3,0)
		1:
			move(0,1)
		2:
			move(1,3)
		3:
			char_pos = 0
			move_options()

func _char_timer_timeout():
	move_check()
