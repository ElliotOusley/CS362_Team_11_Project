# Scripts/CodeBlock.gd
extends Button

# Block properties
@export var block_type: String = ""
@export var display_text: String = ""

func _ready():
	text = display_text

# Drag-and-drop support
func _get_drag_data(_position):
	var drag_data = {"block_type": block_type, "display_text": display_text}
	var preview = Button.new()
	preview.text = display_text
	set_drag_preview(preview)
	return drag_data

# Right-click to remove a block (if inside AnswerArea)
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()
