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

	# If AnswerArea is empty, only allow a Start block.
	if get_child_count() == 0 and block_type != "start":
		print("❌ Must drop a Start block first.")
		return

	var component = TextureRect.new()
	component.texture = data["texture"]
	component.modulate = data.get("modulation", Color(1,1,1,1))
	component.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	component.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	component.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	component.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	component.custom_minimum_size = Vector2(50, 50)
	component.set_meta("block_type", block_type)

	# Attach draggable script.
	component.set_script(preload("res://Scripts/DraggableBlock.gd"))

	var snapped_pos = false
	var new_pos = at_position - component.custom_minimum_size * 0.5

	# If there are existing blocks, attempt to snap relative to them.
	if get_child_count() > 0:
		var best_dist = INF
		var best_target: Control = null
		for child in get_children():
			if child == component:
				continue
			if not (child is TextureRect):
				continue
			var dist = child.position.distance_to(at_position)
			if dist < best_dist:
				best_dist = dist
				best_target = child
		if best_target != null and best_dist < 100:
			# For movement blocks, snap to right; for loops, snap below.
			if block_type in ["move_up", "move_down", "move_left", "move_right"]:
				new_pos = best_target.position + Vector2(best_target.size.x - 13, 0)
				snapped_pos = true
			elif block_type in ["for_loop", "while_loop"]:
				new_pos = best_target.position + Vector2(0, best_target.size.y-5)
				snapped_pos = true
			elif block_type == "start":
				snapped_pos = true
		else:
			# If no valid snap found, allow free drop only for a Start block.
			if block_type == "start":
				snapped_pos = true
	else:
		# No children: only allow a Start block.
		snapped_pos = true

	if not snapped_pos:
		print("❌ Could not snap block:", block_type, "No valid attachment. REFUSED.")
		return

	component.position = new_pos
	add_child(component)
	print("✅ Dropped item in DropZoneControl at pos:", new_pos)
