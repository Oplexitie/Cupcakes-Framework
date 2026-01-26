class_name MemeMinigame
extends CanvasLayer

## Mikie's meme rating minigame.
## Player must upvote dank memes and downvote/ignore undank memes.

signal game_started
signal game_ended(won: bool)
signal meme_shown(meme_data: Dictionary)

enum MemeType {
	DANK,    # Old classics - Doge, Illuminati, MLG, etc. UPVOTE THESE
	UNDANK   # Anime, dead trends, etc. DON'T UPVOTE THESE
}

# Meme database - add your meme images here
# Format: { "texture_path": "res://path", "type": MemeType.DANK or UNDANK, "name": "Meme Name" }
var meme_database: Array[Dictionary] = [
	# DANK MEMES (upvote these to survive)
	{"path": "res://Graphics/Minigames/MemeGame/doge.png", "type": MemeType.DANK, "name": "Doge"},
	{"path": "res://Graphics/Minigames/MemeGame/illuminati.png", "type": MemeType.DANK, "name": "Illuminati"},
	{"path": "res://Graphics/Minigames/MemeGame/mlg.png", "type": MemeType.DANK, "name": "MLG"},
	{"path": "res://Graphics/Minigames/MemeGame/troll_face.png", "type": MemeType.DANK, "name": "Troll Face"},
	{"path": "res://Graphics/Minigames/MemeGame/nyan_cat.png", "type": MemeType.DANK, "name": "Nyan Cat"},
	{"path": "res://Graphics/Minigames/MemeGame/rick_roll.png", "type": MemeType.DANK, "name": "Rick Roll"},

	# UNDANK MEMES (don't upvote these or die)
	{"path": "res://Graphics/Minigames/MemeGame/anime1.png", "type": MemeType.UNDANK, "name": "Anime"},
	{"path": "res://Graphics/Minigames/MemeGame/anime2.png", "type": MemeType.UNDANK, "name": "Anime"},
	{"path": "res://Graphics/Minigames/MemeGame/dead_meme.png", "type": MemeType.UNDANK, "name": "Dead Meme"},
]

@export var time_limit: float = 5.0  # Seconds to vote before auto-fail
@export var memes_per_round: int = 3  # How many memes to judge

# UI References (set in editor or created dynamically)
@onready var panel: Control = $Panel
@onready var meme_display: TextureRect = $Panel/MemeDisplay
@onready var upvote_button: Button = $Panel/UpvoteButton
@onready var downvote_button: Button = $Panel/DownvoteButton
@onready var timer_label: Label = $Panel/TimerLabel
@onready var title_label: Label = $Panel/TitleLabel

var current_meme: Dictionary = {}
var memes_judged: int = 0
var time_remaining: float = 0.0
var is_active: bool = false


func _ready() -> void:
	visible = false
	if upvote_button:
		upvote_button.pressed.connect(_on_upvote)
	if downvote_button:
		downvote_button.pressed.connect(_on_downvote)


func _process(delta: float) -> void:
	if not is_active:
		return

	time_remaining -= delta
	if timer_label:
		timer_label.text = "%.1f" % maxf(time_remaining, 0.0)

	if time_remaining <= 0:
		# Time ran out - that's a fail
		_end_game(false)


func start_game() -> void:
	## Begins the meme minigame.
	if meme_database.is_empty():
		push_warning("MemeMinigame: No memes in database!")
		game_ended.emit(true)  # Auto-win if no memes configured
		return

	is_active = true
	memes_judged = 0
	visible = true
	game_started.emit()

	_show_next_meme()


func _show_next_meme() -> void:
	## Displays a random meme for the player to judge.
	current_meme = meme_database.pick_random()
	time_remaining = time_limit

	# Load and display meme texture
	if meme_display:
		var texture := load(current_meme.path) as Texture2D
		if texture:
			meme_display.texture = texture
		else:
			# Fallback if texture not found - show placeholder
			push_warning("MemeMinigame: Could not load meme texture: " + current_meme.path)

	if title_label:
		title_label.text = "RATE THIS MEME"

	meme_shown.emit(current_meme)


func _on_upvote() -> void:
	## Player upvoted the current meme.
	if not is_active:
		return

	if current_meme.type == MemeType.DANK:
		# Correct! Dank memes should be upvoted
		_meme_judged_correctly()
	else:
		# Wrong! Upvoted an undank meme
		_end_game(false)


func _on_downvote() -> void:
	## Player downvoted the current meme.
	if not is_active:
		return

	if current_meme.type == MemeType.UNDANK:
		# Correct! Undank memes should be downvoted
		_meme_judged_correctly()
	else:
		# Wrong! Downvoted a dank meme
		_end_game(false)


func _meme_judged_correctly() -> void:
	memes_judged += 1

	if memes_judged >= memes_per_round:
		# Survived all memes!
		_end_game(true)
	else:
		# Show next meme
		_show_next_meme()


func _end_game(won: bool) -> void:
	is_active = false
	visible = false
	game_ended.emit(won)


func add_meme(texture_path: String, type: MemeType, meme_name: String = "") -> void:
	## Add a meme to the database at runtime.
	meme_database.append({
		"path": texture_path,
		"type": type,
		"name": meme_name
	})


func clear_memes() -> void:
	## Clear all memes from database.
	meme_database.clear()
