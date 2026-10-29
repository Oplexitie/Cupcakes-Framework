extends Node2D

signal tablet_entered
signal tablet_entering
signal tablet_exited
signal tablet_exiting

const HOVER_FADE_DURATION: float = 0.3

var is_tablet_up: bool = false
var tweener: Tween

@onready var tablet_button: TextureButton = $Tablet_Button
@onready var tablet_sprite: AnimatedSprite2D = $Tablet_Sprite

func tablet_button_clicked() -> void:
	# This function handles if the tablet animation should be played fowards or backwards
	if not is_tablet_up:
		tablet_sprite.play(&"lift")
		tablet_sprite.visible = true
		tablet_entering.emit()
	else:
		tablet_sprite.play_backwards(&"lift")
		tablet_button.disabled = true
		tablet_exiting.emit()

func tablet_animation_finished() -> void:
	if not is_tablet_up:
		is_tablet_up = true
		tablet_entered.emit()
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		tablet_button.disabled = false
		tablet_exited.emit()

func tablet_button_hovered(alpha: float) -> void:
	if tweener: tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, ^"modulate:a", alpha, HOVER_FADE_DURATION)
