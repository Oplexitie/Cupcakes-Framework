extends AI

## Mikie12662 - The Meme Lord
## - Appears randomly during the night
## - Forces player into a meme minigame
## - Upvote dank memes (old classics) = survive
## - Upvote undank memes (anime, etc.) = death

signal minigame_triggered
signal minigame_completed(survived: bool)

# Appearance settings
@export var min_appear_interval: float = 45.0
@export var max_appear_interval: float = 90.0
@export var appear_chance: float = 0.3  # 30% chance when timer fires

# State
var appear_timer: float = 0.0
var next_appear_time: float = 0.0
var is_minigame_active: bool = false

# Reference to the meme minigame (set in editor or by game manager)
var meme_minigame: MemeMinigame


func _ready() -> void:
	character = 1  # Mikie uses index 1 in rooms array
	_reset_appear_timer()


func _process(delta: float) -> void:
	if is_minigame_active:
		return

	appear_timer += delta
	if appear_timer >= next_appear_time:
		_try_appear()
		_reset_appear_timer()


func _reset_appear_timer() -> void:
	appear_timer = 0.0
	next_appear_time = randf_range(min_appear_interval, max_appear_interval)


func _try_appear() -> void:
	## Roll for appearance, then trigger minigame if successful.
	if not is_active:
		return

	if randf() < appear_chance:
		trigger_minigame()


func trigger_minigame() -> void:
	## Forces the meme minigame to start.
	is_minigame_active = true
	minigame_triggered.emit()

	if meme_minigame:
		meme_minigame.start_game()
		# Connect to minigame result if not already connected
		if not meme_minigame.game_ended.is_connected(_on_minigame_ended):
			meme_minigame.game_ended.connect(_on_minigame_ended)


func _on_minigame_ended(won: bool) -> void:
	is_minigame_active = false
	minigame_completed.emit(won)

	if not won and game_manager:
		game_manager.trigger_death()


func force_appear() -> void:
	## Debug/testing: Force Mikie to appear immediately.
	trigger_minigame()


# Mikie doesn't use normal room movement
func move_options() -> void:
	pass


func move_check() -> void:
	pass
