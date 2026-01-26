@abstract
class_name AI
extends Node

## Base class for all animatronic AI.
## Provides difficulty-scaled movement and cross-character signaling.

signal character_moved(from_room: int, to_room: int)
signal reached_office
signal attack_started
signal attack_blocked

enum State {ABSENT, PRESENT, ALT_1, ALT_2}

@export_enum("Red", "Green", "Tony", "Squish", "Kiber", "Conedude", "Ellie", "Ciaaik", "Kitty", "Poke") var character: int
@export var camera: Camera
@export var is_active: bool = true  # Can be disabled by Conedude's presence

var ai_level: int
var step: int
var current_room: int
var speed_multiplier: float = 1.0  # For Kiber's judgment acceleration

# Reference to game systems (set by ai_manager)
var game_manager: GameManager
var corruption_system: CorruptionSystem
var audio_disruption: AudioDisruptionSystem
var rage_system: RageSystem
var door_system: DoorSystem


func has_passed_check() -> bool:
	## Handles whether character moves or not (depending on ai_level).
	## Higher ai_level = more likely to move.
	var effective_level := int(ai_level * speed_multiplier)
	return effective_level >= randi_range(1, 20)


func _is_room_empty(room: int) -> bool:
	return camera.rooms[room].max() == State.ABSENT


func move_check() -> void:
	if not is_active:
		return
	if has_passed_check():
		move_options()


func move_options() -> void:
	## Override in subclass to define movement patterns.
	pass


func move_to(target_room: int, new_state: int = State.PRESENT, move_step: int = 1) -> void:
	## Handles character movement from one room to another.
	## And character state changes in a room (handled by new_state).
	var from_room := current_room
	step += move_step

	camera.rooms[current_room][character] = State.ABSENT
	camera.rooms[target_room][character] = new_state

	camera.update_feeds([current_room, target_room])
	current_room = target_room

	character_moved.emit(from_room, target_room)


func set_active(active: bool) -> void:
	## Enable or disable this AI (used by Conedude to freeze others).
	is_active = active


func accelerate(multiplier: float) -> void:
	## Increase movement speed (used by Kiber's judgment).
	speed_multiplier *= multiplier


func reset_speed() -> void:
	speed_multiplier = 1.0
