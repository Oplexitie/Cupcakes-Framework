extends Node2D
# warning-ignore-all:return_value_discarded

export var office_path: NodePath
export var camera_path: NodePath

var is_tablet_up: bool = false

onready var tablet_button: TextureButton = $TabletButton/Button
onready var tablet_sprite: AnimatedSprite = $TabletSprite
onready var tweener: Tween = $Tween
onready var office = get_node(office_path)
onready var camera = get_node(camera_path)

func _on_click() -> void:
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
	# At the end of the tablet animation, this activates and disables nodes
	if not is_tablet_up:
		is_tablet_up = true
		camera.visible = true
		camera.play_static()
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		office.can_move = true
		tablet_button.disabled = false

func _on_mouse_event(alpha: float) -> void:
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, alpha, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
