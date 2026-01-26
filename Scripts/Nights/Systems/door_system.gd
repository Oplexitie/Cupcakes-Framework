class_name DoorSystem
extends Node

## Manages door states and interference (Squish's door locking).

signal door_state_changed(door_id: int, is_closed: bool)
signal door_jammed(door_id: int, jammed_closed: bool)
signal door_unjammed(door_id: int)

enum DoorState {
	OPEN,
	CLOSED,
	JAMMED_OPEN,
	JAMMED_CLOSED
}

# door_id -> DoorState
var door_states: Dictionary = {}
# door_id -> jam duration remaining
var jam_timers: Dictionary = {}

@export var default_door_count: int = 2
@export var door_close_speed: float = 1.0  # Modified by corruption


func _ready() -> void:
	for i in default_door_count:
		door_states[i] = DoorState.OPEN


func _process(delta: float) -> void:
	# Process jam timers
	var to_unjam: Array[int] = []
	for door_id in jam_timers:
		jam_timers[door_id] -= delta
		if jam_timers[door_id] <= 0:
			to_unjam.append(door_id)

	for door_id in to_unjam:
		unjam_door(door_id)


func toggle_door(door_id: int) -> bool:
	## Player toggles a door. Returns true if successful.
	var state: DoorState = door_states.get(door_id, DoorState.OPEN)

	# Can't toggle jammed doors
	if state == DoorState.JAMMED_OPEN or state == DoorState.JAMMED_CLOSED:
		return false

	if state == DoorState.OPEN:
		door_states[door_id] = DoorState.CLOSED
		door_state_changed.emit(door_id, true)
	else:
		door_states[door_id] = DoorState.OPEN
		door_state_changed.emit(door_id, false)

	return true


func close_door(door_id: int) -> bool:
	var state: DoorState = door_states.get(door_id, DoorState.OPEN)
	if state == DoorState.JAMMED_OPEN or state == DoorState.JAMMED_CLOSED:
		return false
	if state != DoorState.CLOSED:
		door_states[door_id] = DoorState.CLOSED
		door_state_changed.emit(door_id, true)
	return true


func open_door(door_id: int) -> bool:
	var state: DoorState = door_states.get(door_id, DoorState.OPEN)
	if state == DoorState.JAMMED_OPEN or state == DoorState.JAMMED_CLOSED:
		return false
	if state != DoorState.OPEN:
		door_states[door_id] = DoorState.OPEN
		door_state_changed.emit(door_id, false)
	return true


func jam_door(door_id: int, jammed_closed: bool, duration: float) -> void:
	## Squish's ability - jams a door open or closed temporarily.
	door_states[door_id] = DoorState.JAMMED_CLOSED if jammed_closed else DoorState.JAMMED_OPEN
	jam_timers[door_id] = duration
	door_jammed.emit(door_id, jammed_closed)


func unjam_door(door_id: int) -> void:
	jam_timers.erase(door_id)
	var was_closed := door_states.get(door_id, DoorState.OPEN) == DoorState.JAMMED_CLOSED
	door_states[door_id] = DoorState.CLOSED if was_closed else DoorState.OPEN
	door_unjammed.emit(door_id)


func is_door_closed(door_id: int) -> bool:
	var state: DoorState = door_states.get(door_id, DoorState.OPEN)
	return state == DoorState.CLOSED or state == DoorState.JAMMED_CLOSED


func is_door_jammed(door_id: int) -> bool:
	var state: DoorState = door_states.get(door_id, DoorState.OPEN)
	return state == DoorState.JAMMED_OPEN or state == DoorState.JAMMED_CLOSED


func can_block_attack(door_id: int) -> bool:
	## Returns true if this door can block an animatronic attack.
	return is_door_closed(door_id)


func get_effective_close_speed(corruption_system: CorruptionSystem = null) -> float:
	if corruption_system:
		return door_close_speed * corruption_system.get_door_speed_multiplier()
	return door_close_speed


func reset() -> void:
	for door_id in door_states:
		door_states[door_id] = DoorState.OPEN
	jam_timers.clear()
