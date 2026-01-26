extends Camera

## Camera setup for Hellish Nights.
## Simplified for single-character display per room with interference support.

enum {ROOM_01, ROOM_02, ROOM_03, ROOM_04}

# Character index for Tony
const TONY_INDEX: int = 0  # Tony uses index 0 in rooms array

# Reference to interference system for Ciaaik/Kitty effects
var camera_interference: CameraInterferenceSystem


func set_feed(feed_to_update: int) -> void:
	var room_state: Array = rooms[feed_to_update]
	var room_feed: Sprite2D = all_feeds[feed_to_update]

	# Check for camera interference first
	if camera_interference:
		var interference_type := camera_interference.get_interference_type(feed_to_update)
		match interference_type:
			CameraInterferenceSystem.InterferenceType.BLOCKED:
				# Show Ciaaik's face (frame 0 reserved for blocker)
				room_feed.frame = 0
				return
			CameraInterferenceSystem.InterferenceType.BLACKOUT:
				# Could hide sprite or show black frame
				room_feed.visible = false
				return
			CameraInterferenceSystem.InterferenceType.WRONG_FEED:
				# Show different room's state instead
				var actual_room := camera_interference.get_actual_feed(feed_to_update)
				if actual_room != feed_to_update:
					room_state = rooms[actual_room]

	room_feed.visible = true

	# Determine frame based on Tony's presence and state
	# Frame layout assumption:
	#   0 = Empty room
	#   1 = Tony present (normal)
	#   2 = Tony tantrum pose (if applicable)

	var tony_state: int = _get_character_state(room_state, TONY_INDEX)

	match tony_state:
		State.ABSENT:
			room_feed.frame = 0  # Empty
		State.PRESENT:
			room_feed.frame = 1  # Tony normal
		State.ALT_1:
			room_feed.frame = 2  # Tony tantrum/alt pose
		State.ALT_2:
			room_feed.frame = 3  # Another alt pose if needed


func _get_character_state(room_state: Array, char_index: int) -> int:
	## Safely gets character state from room array.
	if char_index < room_state.size():
		return room_state[char_index]
	return State.ABSENT


func is_camera_accessible(room_id: int) -> bool:
	## Returns whether this camera can be viewed (not locked by Kitty).
	if camera_interference:
		return camera_interference.is_camera_accessible(room_id)
	return true


func on_camera_clicked(room_id: int) -> bool:
	## Handle click on camera feed - for punching Ciaaik.
	## Returns true if click was consumed.
	if camera_interference and camera_interference.is_camera_blocked(room_id):
		camera_interference.punch_blocker(room_id)
		update_feeds([room_id])
		return true
	return false
