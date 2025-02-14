extends HBoxContainer

@onready var CodeBlockScene = preload("res://Scenes/CodeBlock.tscn")



func _ready():
	# Ensure it can receive drops
	z_index = 10
	visible = true
	size = Vector2(300, 100)
	modulate = Color(1, 0, 0, 0.5)
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Add a debug background color
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 0, 0, 0.5)  # Red with 50% transparency
	add_theme_stylebox_override("panel", style)

	print("✅ AnswerArea ready, mouse_filter set to PASS, size:", size)

# This function is called to determine if the container accepts drop data
func can_drop_data(_position, data) -> bool:
	var can_drop = data is Dictionary and data.has("block_type") and data.has("display_text")
	print("🟢 can_drop_data called - Accepting?", can_drop, " Data:", data)
	return can_drop

# This function is called when data is dropped into the container
func drop_data(_position, data):
	print("AnswerArea drop_data called with data:", data)

	if data.has("block_type") and data.has("display_text"):
		print("✅ Dropping block:", data["display_text"])  # Debug log

		var new_block = CodeBlockScene.instantiate()
		new_block.block_type = data["block_type"]
		new_block.display_text = data["display_text"]
		new_block.text = data["display_text"]

		add_child(new_block)  # Add block to AnswerArea
		new_block.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# Ensure the layout updates correctly
		queue_redraw()
		get_parent().queue_redraw()
	else:
		print("❌ ERROR: Drop failed, invalid data format:", data)
