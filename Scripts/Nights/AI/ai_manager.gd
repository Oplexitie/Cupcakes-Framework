extends Node

## Manages AI initialization and system connections.

@export_group("Original Characters")
@export_range(0, 20) var red_level: int
@export_range(0, 20) var green_level: int

@export_group("Main Cast")
@export_range(0, 20) var tony_level: int
@export_range(0, 20) var squish_level: int
@export_range(0, 20) var kiber_level: int
@export_range(0, 20) var conedude_level: int
@export_range(0, 20) var ellie_level: int
@export_range(0, 20) var poke_level: int

@export_group("Support Cast")
@export_range(0, 20) var ciaaik_level: int
@export_range(0, 20) var kitty_level: int
@export_range(0, 20) var mikie_level: int

@export_group("Supercharged Variants")
@export_range(0, 20) var mad_conedude_level: int
@export_range(0, 20) var crazed_tony_level: int
@export_range(0, 20) var infernal_kiber_level: int
@export_range(0, 20) var busted_squish_level: int

# System references (assign in editor or find at runtime)
@export var game_manager: GameManager
@export var corruption_system: CorruptionSystem
@export var audio_disruption: AudioDisruptionSystem
@export var rage_system: RageSystem
@export var door_system: DoorSystem
@export var meme_minigame: MemeMinigame


func _ready() -> void:
	randomize()
	_initialize_char_levels()
	_connect_systems()


func _initialize_char_levels() -> void:
	_set_ai_level("Red", red_level)
	_set_ai_level("Green", green_level)
	_set_ai_level("Tony", tony_level)
	_set_ai_level("Squish", squish_level)
	_set_ai_level("Kiber", kiber_level)
	_set_ai_level("Conedude", conedude_level)
	_set_ai_level("Ellie", ellie_level)
	_set_ai_level("Poke", poke_level)
	_set_ai_level("Ciaaik", ciaaik_level)
	_set_ai_level("Kitty", kitty_level)
	_set_ai_level("MadConedude", mad_conedude_level)
	_set_ai_level("CrazedTony", crazed_tony_level)
	_set_ai_level("InfernalKiber", infernal_kiber_level)
	_set_ai_level("BustedSquish", busted_squish_level)
	_set_ai_level("Mikie", mikie_level)


func _set_ai_level(node_name: String, level: int) -> void:
	var node := get_node_or_null(node_name) as AI
	if node:
		node.ai_level = level


func _connect_systems() -> void:
	## Connects game systems to all AI nodes.
	for child in get_children():
		if child is AI:
			child.game_manager = game_manager
			child.corruption_system = corruption_system
			child.audio_disruption = audio_disruption
			child.rage_system = rage_system
			child.door_system = door_system

	# Special connection for Mikie's meme minigame
	var mikie := get_node_or_null("Mikie")
	if mikie and meme_minigame:
		mikie.meme_minigame = meme_minigame
