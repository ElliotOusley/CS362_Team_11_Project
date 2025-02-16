extends Button

@export var block_type: String = ""
@export var display_text: String = ""

@onready var ICONS := {
	"move_up": preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down": preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left": preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png")
}

func _ready():
	# Ensure block_type is valid
	if block_type == "":
		print("⚠️ WARNING: block_type is empty! Defaulting to 'move_up'.")
		block_type = "move_up"

	# Ensure display_text is valid
	if display_text == "":
		display_text = block_type.capitalize().replace("_", " ")  # "Move Up", "Move Left", etc.

	text = display_text
	z_index = 10
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Set icon if it exists
	if ICONS.has(block_type):
		icon = ICONS[block_type]
		expand_icon = true
		icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		print("❌ ERROR: Missing sprite for block_type:", block_type)

# --------------------------------------------------
# ✅ Drag-and-Drop Functionality
# --------------------------------------------------
func _get_drag_data(_position):
	var drag_data = {
		"block_type": block_type,
		"display_text": display_text
	}
	print("🟢 Dragging block:", drag_data)

	# Create a drag preview
	var preview = Button.new()
	preview.z_index = 100
	preview.text = display_text
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview.add_theme_font_size_override("font_size", 16)  # Make text more readable

	if ICONS.has(block_type):
		preview.icon = ICONS[block_type]
		preview.expand_icon = true
		preview.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		print("⚠️ WARNING: Missing icon for block_type:", block_type)

	set_drag_preview(preview)
	return drag_data

# --------------------------------------------------
# ✅ Allow Right-Click to Remove from AnswerArea
# --------------------------------------------------
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()  # Removes the block from AnswerArea
