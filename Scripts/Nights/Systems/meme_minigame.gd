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

# Meme database - uses actual assets from Graphics/Characters/Mikie/
var meme_database: Array[Dictionary] = [
	# DANK MEMES (upvote these to survive)
	{"path": "res://Graphics/Characters/Mikie/dank memes/79c8d8edfa6ec31bbce482b082e0b8de.png", "type": MemeType.DANK, "name": "Dank 1"},
	{"path": "res://Graphics/Characters/Mikie/dank memes/7anehc.png", "type": MemeType.DANK, "name": "Dank 2"},
	{"path": "res://Graphics/Characters/Mikie/dank memes/DtOSPsRXoAAQ-P_.jpg", "type": MemeType.DANK, "name": "Dank 3"},
	{"path": "res://Graphics/Characters/Mikie/dank memes/avatars-000445817805-nlylxn-t108.png", "type": MemeType.DANK, "name": "Dank 4"},
	{"path": "res://Graphics/Characters/Mikie/dank memes/dank.png", "type": MemeType.DANK, "name": "Dank 5"},
	{"path": "res://Graphics/Characters/Mikie/dank memes/o590h4swjt441.png", "type": MemeType.DANK, "name": "Dank 6"},

	# UNDANK MEMES (don't upvote these or die)
	{"path": "res://Graphics/Characters/Mikie/undank memes BOII/1c6207b5866f4587224215bc2b1b34d1.jpg", "type": MemeType.UNDANK, "name": "Undank 1"},
	{"path": "res://Graphics/Characters/Mikie/undank memes BOII/a-possibility-in-the-future-v0-a.png", "type": MemeType.UNDANK, "name": "Undank 2"},
	{"path": "res://Graphics/Characters/Mikie/undank memes BOII/all-he-did-was-stand-there-v0-xz.png", "type": MemeType.UNDANK, "name": "Undank 3"},
	{"path": "res://Graphics/Characters/Mikie/undank memes BOII/images (1).jpg", "type": MemeType.UNDANK, "name": "Undank 4"},
	{"path": "res://Graphics/Characters/Mikie/undank memes BOII/images.jpg", "type": MemeType.UNDANK, "name": "Undank 5"},
]

@export var time_limit: float = 5.0  # Seconds to vote before auto-fail
@export var memes_per_round: int = 3  # How many memes to judge

# Mikie's character sprites
const MIKIE_NORMAL := "res://Graphics/Characters/Mikie/normalmikie.png"
const MIKIE_ENRAGED := "res://Graphics/Characters/Mikie/enragedmikie.png"
const MIKIE_UNAMUSED := "res://Graphics/Characters/Mikie/unamused.png"
const UPVOTE_TEXTURE := "res://Graphics/Characters/Mikie/updoot.png"
const DOWNVOTE_TEXTURE := "res://Graphics/Characters/Mikie/downbote.png"

# UI References (set in editor or created dynamically)
@onready var panel: Control = $Panel
@onready var meme_display: TextureRect = $Panel/MemeDisplay
@onready var mikie_display: TextureRect = $Panel/MikieDisplay  # Shows Mikie's reactions
@onready var upvote_button: TextureButton = $Panel/UpvoteButton
@onready var downvote_button: TextureButton = $Panel/DownvoteButton
@onready var timer_label: Label = $Panel/TimerLabel
@onready var title_label: Label = $Panel/TitleLabel

var current_meme: Dictionary = {}
var memes_judged: int = 0
var time_remaining: float = 0.0
var is_active: bool = false

# Preloaded textures
var mikie_normal_tex: Texture2D
var mikie_enraged_tex: Texture2D
var mikie_unamused_tex: Texture2D


func _ready() -> void:
	visible = false

	# Preload Mikie's textures
	mikie_normal_tex = load(MIKIE_NORMAL)
	mikie_enraged_tex = load(MIKIE_ENRAGED)
	mikie_unamused_tex = load(MIKIE_UNAMUSED)

	# Set up button textures and connections
	if upvote_button:
		upvote_button.texture_normal = load(UPVOTE_TEXTURE)
		upvote_button.pressed.connect(_on_upvote)
	if downvote_button:
		downvote_button.texture_normal = load(DOWNVOTE_TEXTURE)
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

	# Show Mikie's normal face
	_set_mikie_expression(mikie_normal_tex)

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

	# Show Mikie's reaction before hiding
	if won:
		_set_mikie_expression(mikie_unamused_tex)  # Mikie is unamused you survived
	else:
		_set_mikie_expression(mikie_enraged_tex)  # Mikie is enraged you failed

	# Brief delay to show reaction, then hide
	await get_tree().create_timer(0.5).timeout
	visible = false
	game_ended.emit(won)


func _set_mikie_expression(texture: Texture2D) -> void:
	## Updates Mikie's displayed expression.
	if mikie_display and texture:
		mikie_display.texture = texture


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
