extends Panel

@onready var SingleMoveScene = preload("res://Scenes/Item.tscn")
@onready var StartItemScene    = preload("res://Scenes/StartItem.tscn")
@onready var ForLoopItemScene  = preload("res://Scenes/ForLoopItem.tscn")
@onready var WhileLoopItemScene = preload("res://Scenes/WhileLoopItem.tscn")

func _ready():
	# Enable drop functionality.
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	z_index = 10
	visible = true
	size = Vector2(300, 100)
	mouse_filter = Control.MOUSE_FILTER_PASS

	# Debug style: red background with transparency.
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 0, 0, 0.5)
	add_theme_stylebox_override("panel", style)

	print("✅ AnswerArea ready.")

func can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	print("AnswerArea checking drop data:", data)
	# We accept any drop that has a "block_type" key.
	return data is Dictionary and data.has("block_type")

func drop_data(_at_position: Vector2, data: Variant):
	if not can_drop_data(_at_position, data):
		return

	var block_type = data["block_type"]
	var scene_to_instantiate

	match block_type:
		"start":
			scene_to_instantiate = StartItemScene
		"for_loop":
			scene_to_instantiate = ForLoopItemScene
		"while_loop":
			scene_to_instantiate = WhileLoopItemScene
		"move_up", "move_down", "move_left", "move_right":
			scene_to_instantiate = SingleMoveScene
		_:
			# fallback if unknown
			scene_to_instantiate = SingleMoveScene

	var new_item = scene_to_instantiate.instantiate()
	new_item.block_type = block_type
	add_child(new_item)

func _on_mouse_entered():
	# (Optional) Change style or modulate to indicate drop-zone active.
	pass

func _on_mouse_exited():
	# (Optional) Reset style.
	pass
