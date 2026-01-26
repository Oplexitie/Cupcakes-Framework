class_name AudioDisruptionSystem
extends Node

## Manages audio disruption effects (Tony's screaming).
## When active, players cannot hear footsteps, vent sounds, or other audio cues.

signal disruption_started
signal disruption_ended

@export var default_duration: float = 12.0  # 10-15 seconds per spec

var is_disrupted: bool = false
var disruption_timer: float = 0.0


func _process(delta: float) -> void:
	if not is_disrupted:
		return

	disruption_timer -= delta
	if disruption_timer <= 0.0:
		_end_disruption()


func trigger_disruption(duration: float = -1.0) -> void:
	## Triggers audio disruption for the specified duration.
	## Use -1 for default duration.
	var actual_duration := duration if duration > 0 else default_duration

	# If already disrupted, extend the duration
	if is_disrupted:
		disruption_timer = maxf(disruption_timer, actual_duration)
		return

	is_disrupted = true
	disruption_timer = actual_duration
	disruption_started.emit()


func force_end_disruption() -> void:
	## Immediately ends any active disruption.
	if is_disrupted:
		_end_disruption()


func get_remaining_time() -> float:
	return disruption_timer if is_disrupted else 0.0


func _end_disruption() -> void:
	is_disrupted = false
	disruption_timer = 0.0
	disruption_ended.emit()
