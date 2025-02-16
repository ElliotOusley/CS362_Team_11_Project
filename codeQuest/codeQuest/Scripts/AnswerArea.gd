extends Panel

@onready var ItemScene = preload("res://Scenes/Item.tscn")

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
	if can_drop_data(_at_position, data):
		print("Dropping item:", data)
		var new_item = ItemScene.instantiate()
		new_item.block_type = data["block_type"]
		add_child(new_item)
		queue_redraw()
		get_parent().queue_redraw()
	else:
		print("❌ Invalid drop data:", data)

func _on_mouse_entered():
	# (Optional) Change style or modulate to indicate drop-zone active.
	pass

func _on_mouse_exited():
	# (Optional) Reset style.
	pass
