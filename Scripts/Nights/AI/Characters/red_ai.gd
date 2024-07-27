extends AI

func move_options():
	match char_pos:
		0:
			move(2,0)
		1:
			move(0,1)
		2:
			move(1,2)
		3: 
			char_pos = 0
			move_options()

func _char_timer_timeout():
	move_check()
