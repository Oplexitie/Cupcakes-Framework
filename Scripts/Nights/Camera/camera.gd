extends Node2D
class_name Camera

@export var rooms: Array[Array]

var current_feed: int = 0
var all_feeds: Array[Sprite2D]
var all_buttons: Array[TextureButton]

@onready var animtree: AnimationTree = $AnimationTree

func _ready():
	# Adds the camera feeds and buttons into arrays so they can be synced up in 'func _on_click_cam'
	for i in $CamRooms.get_children(): all_feeds.append(i)
	for i in $CamButtons.get_children(): all_buttons.append(i)
	
	# Gets the camera feed id's, then sets them up with the right frame
	var rooms_to_setup : Array[int] = []
	for i in all_feeds.size(): rooms_to_setup.append(i)	
	update_rooms(rooms_to_setup)

func update_rooms(_rooms_to_update: Array[int]):
	pass

func play_static():
	animtree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late

func switch_feed(to_feed: int):
	# This handles camera switching, but blocks it when clicking the same camera button
	if current_feed != to_feed:
		play_static()
		
		all_feeds[current_feed].visible = false
		all_buttons[current_feed].disabled = false
		
		all_feeds[to_feed].visible = true
		all_buttons[to_feed].disabled = true
		
		current_feed = to_feed
