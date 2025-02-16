extends HBoxContainer

@onready var CodeBlockScene = preload("res://Scenes/CodeBlock.tscn")

func _ready():
	# Make sure the container can receive drops
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	z_index = 10
	visible = true
	size = Vector2(300, 100)
	mouse_filter = Control.MOUSE_FILTER_PASS

	# Debug style: red background with some transparency
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 0, 0, 0.5)
	add_theme_stylebox_override("panel", style)

	print("AnswerArea Visible:", visible)
	print("AnswerArea Size:", size)
	print("AnswerArea Global Position:", global_position)
	print("✅ AnswerArea ready.")

func can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	print("🔍 Checking if AnswerArea can accept data...")

	var can_drop = data is Dictionary and data.has("block_type") and data.has("display_text")
	if can_drop:
		print("🟢 AnswerArea ACCEPTING drop:", data["display_text"])
	else:
		print("❌ AnswerArea REJECTING drop:", data)
	return can_drop

func drop_data(_at_position: Vector2, data: Variant):
	print("AnswerArea drop_data called with data:", data)

	if can_drop_data(_at_position, data):
		print("✅ Dropping block:", data["display_text"])

		var new_block = CodeBlockScene.instantiate()
		new_block.block_type = data["block_type"]
		new_block.display_text = data["display_text"]
		new_block.text = data["display_text"]

		add_child(new_block)
		new_block.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		queue_redraw()
		get_parent().queue_redraw()
	else:
		print("❌ ERROR: Drop failed, invalid data format:", data)

func _on_mouse_entered():
	# Example: changing modulate or style to highlight
	#print("🟢 Mouse entered AnswerArea")
	pass

func _on_mouse_exited():
	# Example: reverting modulate or style
	#print("🔴 Mouse exited AnswerArea")
	pass
