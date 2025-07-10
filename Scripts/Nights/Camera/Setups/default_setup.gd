extends Camera

enum {ROOM_01, ROOM_02, ROOM_03, ROOM_04}

func set_feed(feed_to_update: int) -> void:
	var room_state: Array = rooms[feed_to_update]
	var room_feed: Sprite2D = all_feeds[feed_to_update]
	
	# This handles the camera feeds based on the character positions
	match feed_to_update:
		ROOM_01, ROOM_02:
			match room_state:
				[0,0]:
					room_feed.frame = 3
				[1,0]:
					room_feed.frame = 2
				[0,1]:
					room_feed.frame = 1
				[1,1]:
					room_feed.frame = 0
		ROOM_03:
			match room_state:
				[0,0]:
					room_feed.frame = 1
				[1,0]:
					room_feed.frame = 0
		ROOM_04:
			match room_state:
				[0,0]:
					room_feed.frame = 1
				[0,1]:
					room_feed.frame = 0
