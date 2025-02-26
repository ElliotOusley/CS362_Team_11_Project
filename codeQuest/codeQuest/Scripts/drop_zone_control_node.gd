extends Panel

@onready var ICONS: Dictionary = {
	"move_up":    preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down":  preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left":  preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png"),
	"start":      preload("res://Sprites/CodeBlockSprites/start.png"),
	"for_loop":   preload("res://Sprites/CodeBlockSprites/start.png"),
	"while_loop": preload("res://Sprites/CodeBlockSprites/start.png")
}

func _ready():
	print("DropZoneControl READY. I'm a Panel for dropping items.")

func _can_drop_data(_pos, data):
	if not (data is Dictionary and data.has("block_type") and data.has("texture")):
		return false
	return true

func _drop_data(at_position, data):
	print("DropZoneControl _drop_data called with data:", data)
	if not (data is Dictionary and data.has("texture") and data.has("block_type")):
		print("❌ ERROR: Dropped item does not contain valid texture or block_type!")
		return

	var block_type = data["block_type"]

	# If the AnswerArea is empty, only allow a Start block.
	if get_child_count() == 0 and block_type != "start":
		print("❌ Must drop a Start block first.")
		return

	# Create VBoxContainer for the block
	var container = VBoxContainer.new()
	container.custom_minimum_size = Vector2(70, 70)
	container.mouse_filter = Control.MOUSE_FILTER_PASS
	container.alignment = BoxContainer.ALIGNMENT_CENTER

	# Create a control to act as a container (ensures the label is inside the block)
	var content_wrapper = Control.new()
	content_wrapper.custom_minimum_size = Vector2(70, 70)
	content_wrapper.anchor_left = 0.0
	content_wrapper.anchor_right = 1.0
	content_wrapper.anchor_top = 0.0
	content_wrapper.anchor_bottom = 1.0
	content_wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_wrapper.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Create the icon
	var icon = TextureRect.new()
	icon.texture = data["texture"]
	icon.modulate = data.get("modulation", Color(1,1,1,1))
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(70, 70)

	# Add the icon inside content_wrapper (this ensures proper layering)
	content_wrapper.add_child(icon)

	# Create label **ONLY for `for_loop`**:
	if block_type == "for_loop":
		var label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 16)

		# Retrieve loop count from data (default to 2 if missing)
		var count = 2  
		if data.has("loop_count"):
			count = int(data["loop_count"])  
		label.text = "x%d" % count  # Display loop count on label

		# Position label inside content wrapper (so it stays inside the loop block)
		label.anchor_left = 0.0
		label.anchor_right = 1.0
		label.anchor_top = 0.0
		label.anchor_bottom = 1.0
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL

		# Add label inside the content_wrapper
		content_wrapper.add_child(label)

	# Add the content_wrapper inside the container
	container.add_child(content_wrapper)

	# Set metadata for later identification.
	container.set_meta("block_type", block_type)

	# Attach the DraggableBlock script so the entire block remains draggable.
	container.set_script(preload("res://Scripts/DraggableBlock.gd"))

	# **Snap logic remains intact:**
	var snapped_pos = false
	var new_pos = at_position - container.custom_minimum_size * 0.5

	if get_child_count() > 0:
		var best_dist = INF
		var best_target: Control = null
		for child in get_children():
			if child == container:
				continue
			if not (child is VBoxContainer):  # Ensures we're only checking valid blocks
				continue
			var dist = child.position.distance_to(at_position)
			if dist < best_dist:
				best_dist = dist
				best_target = child
		
		if best_target != null and best_dist < 100:
			# Movement blocks snap to the right, Loops snap below.
			if block_type in ["move_up", "move_down", "move_left", "move_right"]:
				new_pos = best_target.position + Vector2(best_target.size.x - 17, 0)
				snapped_pos = true
			elif block_type in ["for_loop", "while_loop"]:
				new_pos = best_target.position + Vector2(0, best_target.size.y - 5)
				snapped_pos = true
			elif block_type == "start":
				snapped_pos = true
		else:
			# If no valid snap found, only allow free drop for Start block.
			if block_type == "start":
				snapped_pos = true
	else:
		# No children: only allow a Start block.
		snapped_pos = true

	# ❌ Prevents placing blocks in invalid spots.
	if not snapped_pos:
		print("❌ Could not snap block:", block_type, "No valid attachment. REFUSED.")
		return

	# Add block at the correct position.
	container.position = new_pos
	add_child(container)
	print("✅ Dropped item in DropZoneControl at pos:", new_pos)
