extends Node2D

# Path to the camera
export var path_cam_stuff : NodePath

var is_tablet_up : bool = false

onready var tablet_button : TextureButton = $Tablet_Button/Button
onready var tweener = $Tween
onready var tablet_sprite : AnimatedSprite = $Tablet_Sprite
onready var cam_stuff : Node2D = get_node(path_cam_stuff)

func on_mouse_enter():
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, 0.5, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()

func on_mouse_exit():
	tweener.interpolate_property(tablet_button, "modulate:a", tablet_button.modulate.a, 0.2, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()

func _on_click():
	# This function handles if the tablet animation should be played fowards or backwards
	if is_tablet_up == false:
		tablet_sprite.play("lift",false)
		tablet_sprite.visible = true
		Global.can_move = false
	else:
		tablet_sprite.play("lift",true)
		tablet_button.disabled = true
		cam_stuff.visible = false

func _tablet_animation_finished():
	# This function handles the nodes that should be active or not, at the end of the tablet animation (up and down)
	if is_tablet_up == false:
		is_tablet_up = true
		cam_stuff.visible = true
		cam_stuff.tree_state_machine.start("static_boot")
		cam_stuff.animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		Global.can_move = true
		tablet_button.disabled = false
