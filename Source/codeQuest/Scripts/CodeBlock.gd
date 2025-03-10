extends Button

@export var block_type: String = ""  # Type of block (e.g., move_up, move_down)
@export var display_text: String = ""  # Display text for the button
var saved_code: String = ""  # Variable to store saved code

# A dictionary to preload block icons based on the block type
@onready var block_icons := {
	"move_up": preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down": preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left": preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png")
}

func _ready():
	# Ensure block_type is valid, set default if missing
	if block_type == "":
		print("⚠️ WARNING: 'block_type' is empty! Defaulting to 'move_up'.")
		block_type = "move_up"

	# Ensure display_text is valid; default to block type description if empty
	if display_text == "":
		display_text = block_type.capitalize().replace("_", " ")

	# Set the button text
	text = display_text
	z_index = 10  # Ensure the button is on top of other UI elements
	mouse_filter = Control.MOUSE_FILTER_STOP  # Prevent mouse events from propagating

	# Set icon if it exists in the dictionary
	if block_icons.has(block_type):
		icon = block_icons[block_type]
		expand_icon = true
		icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		print("❌ ERROR: Missing sprite for block_type:", block_type)

# --------------------------------------------------
# ✅ Drag-and-Drop Functionality
# --------------------------------------------------
func _get_drag_data(position):
	# Store the block's type and display text for dragging
	var drag_data = {
		"block_type": block_type,
		"display_text": display_text
	}
	print("🟢 Dragging block:", drag_data)

	# Create a drag preview button
	var preview = Button.new()
	preview.z_index = 100  # Ensure the preview is on top
	preview.text = display_text
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview.add_theme_font_size_override("font_size", 16)  # Increase font size for readability

	# Set the preview icon if exists
	if block_icons.has(block_type):
		preview.icon = block_icons[block_type]
		preview.expand_icon = true
		preview.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		print("⚠️ WARNING: Missing icon for block_type:", block_type)

	# Set the drag preview
	set_drag_preview(preview)
	return drag_data

# --------------------------------------------------
# ✅ Allow Right-Click to Remove from AnswerArea
# --------------------------------------------------
func _gui_input(event):
	# Detect right-click event and remove the block from the AnswerArea
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			print("🟠 Right-click detected! Removing block from AnswerArea.")
			queue_free()  # Removes the block from AnswerArea

# --------------------------------------------------
# ✅ Save and Load Code Functionality
# --------------------------------------------------
func save_code():
	saved_code = text  # Save the current text of the block
	print("💾 Code saved:", saved_code)

func load_code():
	if saved_code != "":
		text = saved_code  # Restore saved text
		print("🔄 Code loaded:", saved_code)
