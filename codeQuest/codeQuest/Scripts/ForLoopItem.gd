extends MarginContainer

@export var block_type: String = "for_loop"
@export var modulation := Color(1,1,1,1):
	get:
		return modulation
	set(value):
		modulation = value
		if icon_rect:
			icon_rect.modulate = value

@onready var spin_box: SpinBox = $VBoxContainer/HeaderHBox/TextureRect/SpinBox
@onready var label_node: Label = $VBoxContainer/HeaderHBox/Label
@onready var icon_rect: TextureRect = $VBoxContainer/HeaderHBox/TextureRect
@onready var loop_count_label: Label = $VBoxContainer/HeaderHBox/TextureRect/LoopCountLabel
@onready var block_container: HBoxContainer = $VBoxContainer/HeaderHBox/TextureRect/BlockContainer

@onready var ICONS: Dictionary = {
	"for_loop": preload("res://Sprites/CodeBlockSprites/forLoop.png")
}

func _ready():
	# Ensure that all required nodes exist
	if not label_node:
		push_error("❌ Label node not found in ForLoopItem scene!")
		return

	if not spin_box:
		push_error("❌ SpinBox node not found in ForLoopItem scene!")
		return

	if not loop_count_label:
		push_error("❌ LoopCountLabel node not found in ForLoopItem scene!")
		return

	if not icon_rect:
		push_error("❌ TextureRect (icon_rect) not found in ForLoopItem scene!")
		return

	if not block_container:
		push_error("❌ BlockContainer not found in ForLoopItem scene!")
		return

	# Set the for loop icon
	if ICONS.has(block_type):
		icon_rect.texture = ICONS[block_type]
		icon_rect.modulate = modulation
	else:
		push_warning("⚠️ Unknown block_type: " + block_type)

	# Set default loop value
	spin_box.value = 1
	spin_box.min_value = 1  # Ensure that the minimum loop count is at least 1

	# Connect spinbox changes to update the label
	spin_box.value_changed.connect(_on_spin_box_value_changed)

	# Update labels on start
	_on_spin_box_value_changed(spin_box.value)


func get_spin_loop_count() -> int:
	if spin_box:
		return 3
	else:
		push_error("❌ ERROR: SpinBox is NULL in get_spin_loop_count()")
		return 1  # Default to 1 if SpinBox is missing

# **Retrieve the correct loop count**
func get_loop_count() -> int:
	if loop_count_label:
		return int(spin_box.value)
	elif spin_box:
		return int(spin_box.value)
	else:
		push_error("No valid node for loop count!")
		return 1

# **Retrieve the container for looped movement blocks**
func get_block_container() -> HBoxContainer:
	print("\n🔍 get_block_container() called for", self.name)

	if block_container:
		print("   ✅ Found block_container:", block_container.name,
			  "| Full path:", block_container.get_path(),
			  "| child_count before adding:", block_container.get_child_count())

		# Print all children to verify if the node is receiving anything
		for c in block_container.get_children():
			print("       ➡️ Child:", c, "| has_meta('block_type'):", c.has_meta("block_type"))

		return block_container
	else:
		push_error("❌ ERROR: get_block_container() returned NULL! This means `BlockContainer` is missing or path is wrong.")
		return null


# **Handles dragging the ForLoopItem into the AnswerArea**
func _get_drag_data(_position):
	if not icon_rect or not icon_rect.texture:
		push_error("❌ Missing icon texture in ForLoopItem.")
		return null

	var preview = Control.new()
	var icon = TextureRect.new()
	icon.texture = icon_rect.texture
	icon.position = -icon.texture.get_size() / 2
	preview.add_child(icon)
	preview.z_index = 60

	# Show the correct loop count in the drag preview
	var label = Label.new()
	label.text = "x%d" % int(spin_box.value)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	preview.add_child(label)

	set_drag_preview(preview)
	return {
		"block_type": block_type,
		"texture": icon_rect.texture,
		"loop_count": get_spin_loop_count()  # Ensure correct loop count is passed
	}

# **Handles right-click delete action**
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()

# **Updates both the label node and the loop count label**
func _on_spin_box_value_changed(value: float) -> void:
	if label_node:
		label_node.text = "FOR %d times" % int(value)
	else:
		push_error("❌ label_node is NULL! Ensure it is assigned correctly in ForLoopItem scene.")

	if loop_count_label:
		loop_count_label.text = "x%d" % int(value)
	else:
		push_error("❌ loop_count_label is NULL! Ensure it is assigned correctly in ForLoopItem scene.")

	print("🔄 Loop count updated to:", int(value))
