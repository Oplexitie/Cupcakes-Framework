extends Node2D

var curr_cam : int = 0
var cam_rvisual_array : Array = []
var cam_button_array : Array = []

onready var animtree : AnimationTree = $AnimationTree
onready var tree_state_machine = animtree["parameters/StaticState/playback"]

func _ready():
	# Adds the camera images and buttons into seperate arrays so they can be synced
	# up in the '_on_click_cam' function
	var cam_rooms = $Cam_Rooms
	var cam_buttons = $Cam_Buttons
	
	for i in cam_rooms.get_children():
		cam_rvisual_array.append(i)
	for i in cam_buttons.get_children():
		cam_button_array.append(i)
		
	cam_button_array[0].disabled = true
	cam_rooms.update_rooms([0,1,2,3])

func _on_click_cam(extra_arg_0 : int):
	# This function handles switching cameras, while preventing the player from
	# spamming the same camera and getting the same switching animation
	if curr_cam != extra_arg_0:
		tree_state_machine.start("static_boot")
		animtree.advance(0)		# this fixes a problem where the static plays 1 frame too late
		
		cam_rvisual_array[curr_cam].visible = false
		cam_button_array[curr_cam].disabled = false
		
		cam_rvisual_array[extra_arg_0].visible = true
		cam_button_array[extra_arg_0].disabled = true
		
		curr_cam = extra_arg_0
