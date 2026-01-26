class_name CameraInterferenceSystem
extends Node

## Manages camera interference effects (Squish, Ciaaik, Kitty).
## Supports blocking, locking, static, and showing wrong feeds.

signal camera_blocked(room_id: int, blocker: String)
signal camera_unblocked(room_id: int)
signal camera_locked(room_id: int)
signal camera_unlocked(room_id: int)

enum InterferenceType {
	NONE,
	STATIC,         # Just static noise
	WRONG_FEED,     # Shows different room
	BLOCKED,        # Ciaaik's face
	LOCKED,         # Kitty's lock - can't access at all
	BLACKOUT        # Complete blackout
}

# room_id -> InterferenceType
var interference_states: Dictionary = {}
# room_id -> blocker name (for Ciaaik tracking)
var blockers: Dictionary = {}
# room_id -> wrong room to show
var wrong_feeds: Dictionary = {}
# Locked cameras (by Kitty)
var locked_cameras: Array[int] = []


func set_interference(room_id: int, type: InterferenceType, blocker: String = "") -> void:
	interference_states[room_id] = type
	if blocker != "":
		blockers[room_id] = blocker
	if type == InterferenceType.BLOCKED:
		camera_blocked.emit(room_id, blocker)


func clear_interference(room_id: int) -> void:
	var had_interference := interference_states.get(room_id, InterferenceType.NONE) != InterferenceType.NONE
	interference_states.erase(room_id)
	blockers.erase(room_id)
	wrong_feeds.erase(room_id)
	if had_interference:
		camera_unblocked.emit(room_id)


func set_wrong_feed(room_id: int, shows_room: int) -> void:
	## Makes a camera show a different room's feed.
	interference_states[room_id] = InterferenceType.WRONG_FEED
	wrong_feeds[room_id] = shows_room


func lock_camera(room_id: int) -> void:
	## Kitty's ability - completely locks a camera.
	if room_id not in locked_cameras:
		locked_cameras.append(room_id)
		interference_states[room_id] = InterferenceType.LOCKED
		camera_locked.emit(room_id)


func unlock_camera(room_id: int) -> void:
	if room_id in locked_cameras:
		locked_cameras.erase(room_id)
		interference_states.erase(room_id)
		camera_unlocked.emit(room_id)


func unlock_all_cameras() -> void:
	for room_id in locked_cameras.duplicate():
		unlock_camera(room_id)


func get_interference_type(room_id: int) -> InterferenceType:
	return interference_states.get(room_id, InterferenceType.NONE)


func is_camera_accessible(room_id: int) -> bool:
	var state: InterferenceType = interference_states.get(room_id, InterferenceType.NONE)
	return state != InterferenceType.LOCKED


func is_camera_blocked(room_id: int) -> bool:
	return interference_states.get(room_id, InterferenceType.NONE) == InterferenceType.BLOCKED


func get_actual_feed(room_id: int) -> int:
	## Returns what room should actually be shown (for wrong_feed).
	if interference_states.get(room_id, InterferenceType.NONE) == InterferenceType.WRONG_FEED:
		return wrong_feeds.get(room_id, room_id)
	return room_id


func get_blocker(room_id: int) -> String:
	return blockers.get(room_id, "")


func punch_blocker(room_id: int) -> bool:
	## Player clicks on Ciaaik's face to remove him. Returns true if successful.
	if is_camera_blocked(room_id):
		clear_interference(room_id)
		return true
	return false


func get_blocked_camera_count() -> int:
	var count := 0
	for room_id in interference_states:
		if interference_states[room_id] == InterferenceType.BLOCKED:
			count += 1
	return count


func reset() -> void:
	interference_states.clear()
	blockers.clear()
	wrong_feeds.clear()
	locked_cameras.clear()
