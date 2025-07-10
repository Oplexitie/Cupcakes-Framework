extends Node2D

const HOVER_FADE_DURATION: float = 0.3

@export_group("Setup")
@export var camera: Camera
@export var office: Node2D

var is_tablet_up: bool = false
var tweener: Tween

@onready var tablet_button: TextureButton = $Tablet_Button
@onready var tablet_sprite: AnimatedSprite2D = $Tablet_Sprite

func _on_tablet_button_click() -> void:
	# This function handles if the tablet animation should be played fowards or backwards
	if not is_tablet_up:
		tablet_sprite.play("lift")
		tablet_sprite.visible = true
		office.can_move = false
	else:
		tablet_sprite.play_backwards("lift")
		tablet_button.disabled = true
		camera.visible = false

func _tablet_animation_finished() -> void:
	if not is_tablet_up:
		is_tablet_up = true
		camera.visible = true
		camera.play_static()
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		office.can_move = true
		tablet_button.disabled = false

func _on_tablet_button_hover(alpha: float) -> void:
	if tweener: tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, "modulate:a", alpha, HOVER_FADE_DURATION)
