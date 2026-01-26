class_name CorruptionSystem
extends Node

## Manages system corruption effects (Conedude's mechanic).
## Corruption degrades player systems: cameras glitch more, doors slower, power drains faster.

signal corruption_increased(new_level: int)
signal system_corrupted(system: CorruptibleSystem)
signal max_corruption_reached

enum CorruptibleSystem {
	CAMERAS,
	DOORS,
	LIGHTS,
	POWER
}

const MAX_STRIKES: int = 3

@export var camera_glitch_multiplier_per_strike: float = 1.5
@export var door_speed_reduction_per_strike: float = 0.25  # 25% slower per strike
@export var power_drain_multiplier_per_strike: float = 1.3

var strikes: int = 0
var corrupted_systems: Array[CorruptibleSystem] = []

# Calculated debuff values
var camera_glitch_multiplier: float = 1.0
var door_speed_multiplier: float = 1.0
var power_drain_multiplier: float = 1.0


func add_strike(count: int = 1) -> void:
	## Adds corruption strikes. Each strike worsens all systems.
	var old_strikes := strikes
	strikes = mini(strikes + count, MAX_STRIKES)

	if strikes != old_strikes:
		_recalculate_debuffs()
		corruption_increased.emit(strikes)

	if strikes >= MAX_STRIKES:
		max_corruption_reached.emit()


func corrupt_specific_system(system: CorruptibleSystem) -> void:
	## Corrupts a specific system entirely (Mad Conedude's targeted corruption).
	if system not in corrupted_systems:
		corrupted_systems.append(system)
		system_corrupted.emit(system)


func is_system_corrupted(system: CorruptibleSystem) -> bool:
	return system in corrupted_systems


func get_camera_glitch_chance() -> float:
	## Returns increased glitch chance (0.0 = normal, higher = more glitches).
	if is_system_corrupted(CorruptibleSystem.CAMERAS):
		return 1.0  # Always glitching
	return (camera_glitch_multiplier - 1.0) * 0.2  # Convert multiplier to chance


func get_door_speed_multiplier() -> float:
	## Returns door speed multiplier (1.0 = normal, lower = slower).
	if is_system_corrupted(CorruptibleSystem.DOORS):
		return 0.0  # Doors don't work
	return door_speed_multiplier


func get_power_drain_multiplier() -> float:
	## Returns power drain multiplier (1.0 = normal, higher = faster drain).
	if is_system_corrupted(CorruptibleSystem.POWER):
		return 999.0  # Instant drain
	return power_drain_multiplier


func reset() -> void:
	strikes = 0
	corrupted_systems.clear()
	_recalculate_debuffs()


func _recalculate_debuffs() -> void:
	camera_glitch_multiplier = pow(camera_glitch_multiplier_per_strike, strikes)
	door_speed_multiplier = 1.0 - (door_speed_reduction_per_strike * strikes)
	door_speed_multiplier = maxf(door_speed_multiplier, 0.1)  # Never fully stop
	power_drain_multiplier = pow(power_drain_multiplier_per_strike, strikes)
