extends Camera

func set_feed(feed_to_update: int):
	# This handles the camera feeds based on the character positions
	match feed_to_update:
		0:
			match rooms[0]:
				[0,0]:
					all_feeds[0].frame = 3
				[1,0]:
					all_feeds[0].frame = 2
				[0,1]:
					all_feeds[0].frame = 1
				[1,1]:
					all_feeds[0].frame = 0
		1:
			match rooms[1]:
				[0,0]:
					all_feeds[1].frame = 3
				[1,0]:
					all_feeds[1].frame = 2
				[0,1]:
					all_feeds[1].frame = 1
				[1,1]:
					all_feeds[1].frame = 0
		2:
			match rooms[2]:
				[0,0]:
					all_feeds[2].frame = 1
				[1,0]:
					all_feeds[2].frame = 0
		3:
			match rooms[3]:
				[0,0]:
					all_feeds[3].frame = 1
				[0,1]:
					all_feeds[3].frame = 0

func _on_click_cam(clicked_cam: int):
	switch_feed(clicked_cam)
