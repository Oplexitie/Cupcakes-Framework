extends Node2D

@export_group("Setup")
@export var camera: Camera

var is_tablet_up: bool = false
var tweener: Tween

@onready var tablet_button: TextureButton = $Tablet_Button
@onready var tablet_sprite: AnimatedSprite2D = $Tablet_Sprite

func _on_click():
	# This function handles if the tablet animation should be played fowards or backwards
	if not is_tablet_up:
		tablet_sprite.play("lift")
		tablet_sprite.visible = true
		Scroll.can_move = false
	else:
		tablet_sprite.play_backwards("lift")
		tablet_button.disabled = true
		camera.visible = false

func _tablet_animation_finished():
	# At the end of the tablet animation, this activates and disables nodes
	if not is_tablet_up:
		is_tablet_up = true
		camera.visible = true
		camera.play_static()
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		Scroll.can_move = true
		tablet_button.disabled = false

func on_mouse_enter():
	if tweener: tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, "modulate:a", 0.5, 0.3)

func on_mouse_exit():
	if tweener: tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, "modulate:a", 0.2, 0.3)
