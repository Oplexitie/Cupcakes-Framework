extends Node2D

signal tablet_entered
signal tablet_entering
signal tablet_exited
signal tablet_exiting

const HOVER_FADE_DURATION: float = 0.3

var is_tablet_up: bool = false

onready var tablet_button: TextureButton = $TabletButton/Button
onready var tablet_sprite: AnimatedSprite = $TabletSprite
onready var tweener: Tween = $Tween

func tablet_button_clicked() -> void:
	# This function handles if the tablet animation should be played fowards or backwards
	if not is_tablet_up:
		tablet_sprite.play("lift",false)
		tablet_sprite.visible = true
		emit_signal("tablet_entering")
	else:
		tablet_sprite.play("lift",true)
		tablet_button.disabled = true
		emit_signal("tablet_exiting")

func tablet_animation_finished() -> void:
	if not is_tablet_up:
		is_tablet_up = true
		emit_signal("tablet_entered")
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		tablet_button.disabled = false
		emit_signal("tablet_exited")

func tablet_button_hovered(alpha: float) -> void:
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, alpha, HOVER_FADE_DURATION,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
