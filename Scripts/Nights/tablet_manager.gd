extends Node2D
# warning-ignore-all:return_value_discarded

export var off_scroll_path: NodePath
export var camera_path: NodePath

var is_tablet_up : bool = false

onready var tablet_button: TextureButton = $TabletButton/Button
onready var tablet_sprite: AnimatedSprite = $TabletSprite
onready var tweener: Tween = $Tween
onready var off_scroll = get_node(off_scroll_path)
onready var camera = get_node(camera_path)

func _on_click():
	# This function handles if the tablet animation should be played fowards or backwards
	if !is_tablet_up:
		tablet_sprite.play("lift",false)
		tablet_sprite.visible = true
		off_scroll.can_move = false
	else:
		tablet_sprite.play("lift",true)
		tablet_button.disabled = true
		camera.visible = false

func _tablet_animation_finished():
	# At the end of the tablet animation, this activates and disables nodes
	if !is_tablet_up:
		is_tablet_up = true
		camera.visible = true
		camera.tree_state_machine.start("static_boot")
		camera.animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		off_scroll.can_move = true
		tablet_button.disabled = false

func on_mouse_enter():
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, 0.5, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()

func on_mouse_exit():
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, 0.2, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
