extends Node2D
# warning-ignore-all:return_value_discarded

const HOVER_FADE_DURATION: float = 0.3

export var office_path: NodePath
export var camera_path: NodePath

var is_tablet_up: bool = false

onready var tablet_button: TextureButton = $TabletButton/Button
onready var tablet_sprite: AnimatedSprite = $TabletSprite
onready var tweener: Tween = $Tween
onready var office = get_node(office_path)
onready var camera = get_node(camera_path)

func _on_tablet_button_click() -> void:
	# This function handles if the tablet animation should be played fowards or backwards
	if not is_tablet_up:
		tablet_sprite.play("lift",false)
		tablet_sprite.visible = true
		office.can_move = false
	else:
		tablet_sprite.play("lift",true)
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
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, alpha, HOVER_FADE_DURATION,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
