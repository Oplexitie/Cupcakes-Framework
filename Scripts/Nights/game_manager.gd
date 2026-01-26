class_name GameManager
extends Node

## Central game state coordinator for Hellish Nights.
## Manages night progression, win/lose conditions, and cross-system communication.

signal game_started
signal game_over(won: bool)
signal hour_changed(hour: int)
signal player_mistake_made  # For Kiber's judgment system

enum GameState {WAITING, PLAYING, WON, LOST}

const SECONDS_PER_HOUR: float = 90.0  # 90 seconds per in-game hour
const START_HOUR: int = 12  # 12 AM (midnight)
const END_HOUR: int = 6     # 6 AM

@export var auto_start: bool = true

var state: GameState = GameState.WAITING
var current_hour: int = START_HOUR
var night_elapsed: float = 0.0

# Corruption strikes (for Conedude)
var corruption_strikes: int = 0
const MAX_CORRUPTION_STRIKES: int = 3

# Track player patterns (for Conedude's learning)
var camera_check_counts: Dictionary = {}  # room_id -> check_count
var door_usage_counts: Dictionary = {}    # door_id -> usage_count


func _ready() -> void:
	if auto_start:
		start_game()


func _process(delta: float) -> void:
	if state != GameState.PLAYING:
		return

	night_elapsed += delta
	var new_hour := _calculate_current_hour()

	if new_hour != current_hour:
		current_hour = new_hour
		hour_changed.emit(current_hour)

		if current_hour >= END_HOUR:
			_win_game()


func start_game() -> void:
	state = GameState.PLAYING
	current_hour = START_HOUR
	night_elapsed = 0.0
	corruption_strikes = 0
	camera_check_counts.clear()
	door_usage_counts.clear()
	game_started.emit()
	hour_changed.emit(current_hour)


func trigger_death() -> void:
	if state != GameState.PLAYING:
		return
	state = GameState.LOST
	game_over.emit(false)


func add_corruption_strike(count: int = 1) -> void:
	corruption_strikes += count
	if corruption_strikes >= MAX_CORRUPTION_STRIKES:
		trigger_death()


func report_camera_check(room_id: int) -> void:
	## Called when player checks a camera. Used by Conedude to learn patterns.
	camera_check_counts[room_id] = camera_check_counts.get(room_id, 0) + 1


func report_door_usage(door_id: int) -> void:
	## Called when player uses a door. Used by Conedude to learn patterns.
	door_usage_counts[door_id] = door_usage_counts.get(door_id, 0) + 1


func report_player_mistake() -> void:
	## Called when player makes a mistake. Used by Kiber's judgment system.
	player_mistake_made.emit()


func get_most_checked_camera() -> int:
	## Returns the room_id the player checks most often. -1 if no data.
	if camera_check_counts.is_empty():
		return -1
	var max_room := -1
	var max_count := 0
	for room_id in camera_check_counts:
		if camera_check_counts[room_id] > max_count:
			max_count = camera_check_counts[room_id]
			max_room = room_id
	return max_room


func get_most_used_door() -> int:
	## Returns the door_id the player uses most often. -1 if no data.
	if door_usage_counts.is_empty():
		return -1
	var max_door := -1
	var max_count := 0
	for door_id in door_usage_counts:
		if door_usage_counts[door_id] > max_count:
			max_count = door_usage_counts[door_id]
			max_door = door_id
	return max_door


func is_final_hour() -> bool:
	return current_hour >= 5  # 5 AM onwards


func get_night_progress() -> float:
	## Returns 0.0 to 1.0 representing night progression.
	var total_seconds := (END_HOUR - START_HOUR + 12) * SECONDS_PER_HOUR  # +12 for AM wrap
	return clampf(night_elapsed / total_seconds, 0.0, 1.0)


func _calculate_current_hour() -> int:
	var hours_passed := int(night_elapsed / SECONDS_PER_HOUR)
	var hour := START_HOUR + hours_passed
	if hour >= 13:
		hour -= 12  # Wrap from 12 to 1, 2, 3...
	return mini(hour, END_HOUR)


func _win_game() -> void:
	state = GameState.WON
	game_over.emit(true)
