extends Button

@export var block_type: String = ""
@export var display_text: String = ""

# Dictionary linking block types to icons in res://Sprites/CodeBlockSprites/
@onready var ICONS := {
	"move_up":    preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down":  preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left":  preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png")
}

func _ready():
	# Set the text and ensure the block appears on top
	text = display_text
	z_index = 10
	mouse_filter = Control.MOUSE_FILTER_STOP
	if ICONS.has(block_type):
		icon = ICONS[block_type] as Texture2D

# DRAG-AND-DROP SUPPORT (Godot 4 style)
func _get_drag_data(_position):
	var drag_data = {"block_type": block_type, "display_text": display_text}
	
	# Create a preview that will always appear above other UI
	var preview = Button.new()
	preview.z_index = 100
	preview.text = display_text
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if ICONS.has(block_type):
		preview.icon = ICONS[block_type]
		preview.expand_icon = true
		preview.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	set_drag_preview(preview)
	print("Dragging block:", block_type)
	return drag_data

# RIGHT-CLICK TO REMOVE BLOCK (if inside AnswerArea)
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()
