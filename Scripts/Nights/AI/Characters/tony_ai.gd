extends AI

## Tony - The Annoying Screamer
## - Screams randomly, blocking player's audio for 10-15 seconds
## - Moves fast but loud (you hear him coming unless he just screamed)
## - Can throw tantrums: camps in a room screaming until you flash light at him

signal screamed
signal tantrum_started
signal tantrum_ended

enum Room {ROOM_01, ROOM_02, ROOM_03, ROOM_04}

# Door assignment
const TARGET_DOOR: int = 0  # Left door (0 = left, 1 = right)

# Scream settings
@export var min_scream_interval: float = 20.0
@export var max_scream_interval: float = 40.0
@export var disruption_duration: float = 12.0  # 10-15 seconds per spec

# Tantrum settings
@export var tantrum_chance: float = 0.2  # 20% chance to tantrum instead of move
@export var tantrum_scream_interval: float = 5.0  # Screams every 5 sec during tantrum

# Movement path
var movement_path: Array[int] = [Room.ROOM_01, Room.ROOM_02, Room.ROOM_03, Room.ROOM_04]

# State
var is_in_tantrum: bool = false
var scream_timer: float = 0.0
var tantrum_timer: float = 0.0
var next_scream_time: float = 0.0

@onready var move_timer: Timer = $TonyTimer


func _ready() -> void:
	character = 0  # Tony uses index 0 in rooms array
	current_room = Room.ROOM_01
	_reset_scream_timer()


func _process(delta: float) -> void:
	_process_scream_timer(delta)
	_process_tantrum(delta)


func _process_scream_timer(delta: float) -> void:
	if is_in_tantrum:
		return  # Tantrum has its own scream logic

	scream_timer += delta
	if scream_timer >= next_scream_time:
		_do_scream()
		_reset_scream_timer()


func _process_tantrum(delta: float) -> void:
	if not is_in_tantrum:
		return

	tantrum_timer += delta
	if tantrum_timer >= tantrum_scream_interval:
		_do_scream()
		tantrum_timer = 0.0


func _reset_scream_timer() -> void:
	scream_timer = 0.0
	next_scream_time = randf_range(min_scream_interval, max_scream_interval)


func _do_scream() -> void:
	## Triggers a scream, disrupting player audio.
	if audio_disruption:
		audio_disruption.trigger_disruption(disruption_duration)

	# Increase Poke's rage if rage system exists
	if rage_system:
		rage_system.on_scream(1.0)

	screamed.emit()


func move_options() -> void:
	if is_in_tantrum:
		return  # Can't move during tantrum

	# Chance to start tantrum instead of moving
	if randf() < tantrum_chance:
		_start_tantrum()
		return

	# Normal movement along path
	var current_index := movement_path.find(current_room)
	if current_index == -1:
		# Not on path, go to start
		move_to(Room.ROOM_01)
		return

	var next_index := current_index + 1
	if next_index >= movement_path.size():
		# Reached end of path - at office door
		_arrive_at_office()
	else:
		move_to(movement_path[next_index])


func _start_tantrum() -> void:
	## Tony throws a tantrum - camps and screams until light flashed.
	is_in_tantrum = true
	tantrum_timer = 0.0
	_do_scream()  # Immediate scream when tantrum starts

	# Pause movement timer during tantrum
	if move_timer:
		move_timer.paused = true

	tantrum_started.emit()


func end_tantrum() -> void:
	## Called when player flashes light at Tony.
	if not is_in_tantrum:
		return

	is_in_tantrum = false
	tantrum_timer = 0.0

	# Resume movement timer
	if move_timer:
		move_timer.paused = false

	# Reset to start of path
	move_to(Room.ROOM_01, State.PRESENT, -step)

	tantrum_ended.emit()


func flash_light() -> void:
	## Player flashes light - ends tantrum if active.
	if is_in_tantrum:
		end_tantrum()


func _arrive_at_office() -> void:
	## Tony reached the office via LEFT DOOR - check if blocked.
	reached_office.emit()

	# Check if left door is closed
	if door_system and door_system.is_door_closed(TARGET_DOOR):
		# Blocked! Tony retreats to start
		attack_blocked.emit()
		move_to(Room.ROOM_01, State.PRESENT, -step)
		return

	# Door open - attack succeeds
	attack_started.emit()
	if game_manager:
		game_manager.trigger_death()


func get_movement_sound_audible() -> bool:
	## Returns whether Tony's movement can be heard (not during disruption).
	if audio_disruption:
		return not audio_disruption.is_disrupted
	return true
