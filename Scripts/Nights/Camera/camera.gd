extends Node2D
class_name Camera

@export var rooms: Array[Array]

var current_feed: int = 0
var all_feeds: Array[Sprite2D]
var all_buttons: Array[TextureButton]

@onready var animtree: AnimationTree = $AnimationTree

func _ready() -> void:
	_initialize_buttons()
	_initialize_feeds()

func _initialize_buttons() -> void:
	# Adds the camera feeds and buttons into arrays so they can be synced up in 'func _on_click_cam'
	all_feeds.append_array($CamRooms.get_children())
	all_buttons.append_array($CamButtons.get_children())

func _initialize_feeds() -> void:
	# Gets the camera feed id's, then sets them up with the right frame
	update_feeds(type_convert(range(all_feeds.size()), TYPE_PACKED_INT32_ARRAY))

func set_feed(_feed_to_update: int) -> void:
	pass

func update_feeds(feeds_to_update: Array[int]) -> void:
	for i in feeds_to_update:
		set_feed(i)
		if current_feed == i:
			play_static()

func switch_feed(new_feed: int) -> void:
	# This handles camera switching, but blocks it when clicking the same camera button
	if current_feed != new_feed:
		play_static()
		
		all_feeds[current_feed].visible = false
		all_buttons[current_feed].disabled = false
		
		all_feeds[new_feed].visible = true
		all_buttons[new_feed].disabled = true
		
		current_feed = new_feed

func play_static() -> void:
	animtree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	animtree.advance(0) # this fixes a problem where the static plays 1 frame too late
