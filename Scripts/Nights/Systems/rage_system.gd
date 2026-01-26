class_name RageSystem
extends Node

## Manages Poke's rage meter.
## Rage builds over time and from Tony's screams. Player must actively calm Poke.

signal rage_changed(new_value: float)
signal rage_threshold_reached(threshold: float)
signal enraged  # 100% rage reached
signal calmed   # Rage reduced below danger threshold

const RAGE_MAX: float = 100.0
const DANGER_THRESHOLD: float = 75.0

@export var passive_rage_rate: float = 2.0  # Rage per second (base)
@export var rage_per_scream: float = 15.0   # Rage added per Tony scream
@export var calm_amount: float = 25.0        # Rage removed per calm action
@export var calm_cooldown: float = 3.0       # Seconds between calm actions

var current_rage: float = 0.0
var is_enraged: bool = false
var calm_timer: float = 0.0
var passive_rate_multiplier: float = 1.0  # Increases as night progresses
var is_permanently_enraged: bool = false  # For Poke's final hour


func _process(delta: float) -> void:
	if is_permanently_enraged:
		return

	# Passive rage buildup
	if not is_enraged:
		add_rage(passive_rage_rate * passive_rate_multiplier * delta)

	# Calm cooldown
	if calm_timer > 0:
		calm_timer -= delta


func add_rage(amount: float) -> void:
	## Adds rage. Use negative values to reduce.
	if is_permanently_enraged:
		return

	var old_rage := current_rage
	current_rage = clampf(current_rage + amount, 0.0, RAGE_MAX)

	if current_rage != old_rage:
		rage_changed.emit(current_rage)

	# Check thresholds
	if current_rage >= RAGE_MAX and not is_enraged:
		is_enraged = true
		enraged.emit()
	elif current_rage < DANGER_THRESHOLD and is_enraged:
		is_enraged = false
		calmed.emit()

	# Threshold notifications
	if old_rage < DANGER_THRESHOLD and current_rage >= DANGER_THRESHOLD:
		rage_threshold_reached.emit(DANGER_THRESHOLD)


func on_scream(multiplier: float = 1.0) -> void:
	## Called when Tony screams. Increases rage.
	add_rage(rage_per_scream * multiplier)


func try_calm() -> bool:
	## Player attempts to calm Poke. Returns true if successful.
	if calm_timer > 0:
		return false

	if is_permanently_enraged:
		return false

	add_rage(-calm_amount)
	calm_timer = calm_cooldown
	return true


func set_permanently_enraged() -> void:
	## For Poke's final hour - cannot be calmed.
	is_permanently_enraged = true
	current_rage = RAGE_MAX
	is_enraged = true
	enraged.emit()


func set_night_progress(progress: float) -> void:
	## Updates rage rate based on night progression (0.0 to 1.0).
	## Later hours = faster rage buildup.
	passive_rate_multiplier = 1.0 + (progress * 2.0)  # Up to 3x at end of night


func get_rage_percent() -> float:
	return current_rage / RAGE_MAX


func can_calm() -> bool:
	return calm_timer <= 0 and not is_permanently_enraged


func reset() -> void:
	current_rage = 0.0
	is_enraged = false
	calm_timer = 0.0
	passive_rate_multiplier = 1.0
	is_permanently_enraged = false
