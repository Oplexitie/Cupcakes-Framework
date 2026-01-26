class_name ErrorOverlaySystem
extends CanvasLayer

## Manages error message overlays (Squish's mechanic).
## Error messages stack on screen and must be closed by clicking.

signal error_spawned(error_node: Control)
signal error_closed(error_node: Control)
signal errors_overwhelming  # When too many errors block the view

const MAX_ERRORS_BEFORE_OVERWHELM: int = 5

@export var error_scene: PackedScene  # Assign an error popup scene
@export var auto_spawn_interval: float = 0.0  # 0 = disabled, >0 = auto-spawn rate

var active_errors: Array[Control] = []
var auto_spawn_timer: float = 0.0
var auto_spawn_enabled: bool = false

# Default error messages
var error_messages: Array[String] = [
	"SYSTEM ERROR: Camera feed interrupted",
	"WARNING: Unauthorized access detected",
	"ERROR 0x4E46: Memory corruption",
	"CRITICAL: Security breach in sector 7",
	"ALERT: Door mechanism malfunction",
	"ERROR: Audio subsystem failure",
	"WARNING: Power fluctuation detected",
	"SYSTEM: Reboot required",
	"ERROR 404: Animatronic not found",
	"CRITICAL: Firewall compromised",
]


func _process(delta: float) -> void:
	if auto_spawn_enabled and auto_spawn_interval > 0:
		auto_spawn_timer -= delta
		if auto_spawn_timer <= 0:
			spawn_error()
			auto_spawn_timer = auto_spawn_interval


func spawn_error(custom_message: String = "") -> Control:
	## Spawns an error popup on screen. Returns the created node.
	var error_node: Control

	if error_scene:
		error_node = error_scene.instantiate()
	else:
		# Create a default error panel if no scene assigned
		error_node = _create_default_error()

	# Set message
	var message := custom_message if custom_message != "" else error_messages.pick_random()
	var label := error_node.get_node_or_null("Label") as Label
	if label:
		label.text = message

	# Random position (avoid edges)
	var viewport_size := get_viewport().get_visible_rect().size
	error_node.position = Vector2(
		randf_range(100, viewport_size.x - 400),
		randf_range(100, viewport_size.y - 200)
	)

	add_child(error_node)
	active_errors.append(error_node)
	error_spawned.emit(error_node)

	# Connect close button
	var close_btn := error_node.get_node_or_null("CloseButton") as Button
	if close_btn:
		close_btn.pressed.connect(_on_error_closed.bind(error_node))

	# Check if overwhelming
	if active_errors.size() >= MAX_ERRORS_BEFORE_OVERWHELM:
		errors_overwhelming.emit()

	return error_node


func close_error(error_node: Control) -> void:
	if error_node in active_errors:
		active_errors.erase(error_node)
		error_closed.emit(error_node)
		error_node.queue_free()


func close_all_errors() -> void:
	for error in active_errors.duplicate():
		close_error(error)


func start_auto_spawn(interval: float) -> void:
	auto_spawn_interval = interval
	auto_spawn_timer = interval
	auto_spawn_enabled = true


func stop_auto_spawn() -> void:
	auto_spawn_enabled = false


func get_error_count() -> int:
	return active_errors.size()


func _on_error_closed(error_node: Control) -> void:
	close_error(error_node)


func _create_default_error() -> Control:
	## Creates a simple default error panel.
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(300, 100)

	var vbox := VBoxContainer.new()
	panel.add_child(vbox)

	var label := Label.new()
	label.name = "Label"
	label.text = "ERROR"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

	var close_btn := Button.new()
	close_btn.name = "CloseButton"
	close_btn.text = "OK"
	vbox.add_child(close_btn)

	return panel
