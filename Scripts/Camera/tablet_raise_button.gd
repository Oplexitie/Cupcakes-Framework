extends Node2D

onready var tweener = $"../Tween"
onready var animtree = $"../AnimationTree"
onready var tree_state_machine = animtree["parameters/StaticState/playback"]

onready var view_control = $"../Office"
onready var cam_stuff = $"../Camera_Elements"
onready var tablet_sprite = $"../Tablet"
onready var tablet_button = $TextureButton

var is_tablet_up : bool = false

func on_mouse_enter():
	tweener.interpolate_property(self, "modulate:a", modulate.a, 0.75, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()

func on_mouse_exit():
	tweener.interpolate_property(self, "modulate:a", modulate.a, 0.29, 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()

func _on_click():
	# This function handles if the tablet should be played or not when the button is pressed
	if is_tablet_up == false:
		tablet_sprite.visible = true
		tablet_sprite.play("lift",false)
	else:
		tablet_sprite.play("lift",true)
		tablet_button.disabled = true
		cam_stuff.visible = false

func _tablet_animation_finished():
	# This function handles the nodes that should be active or not, when the tablet is up or down
	if is_tablet_up == false:
		is_tablet_up = true
		cam_stuff.visible = true
		view_control.can_move = false
		tree_state_machine.start("static_boot")
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		view_control.can_move = true
		tablet_button.disabled = false
