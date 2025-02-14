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
	# Set the text
	text = display_text
	
	# If there is an icon for this block_type, assign it
	if ICONS.has(block_type):
		icon = ICONS[block_type] as Texture2D
	
	# (Optional) adjust the button size to fit the icon nicely:
	#   - You can set 'expand_icon' or change 'stretch_mode' in the Inspector.
	#   - Or manually do 'rect_min_size = icon.get_size()' if you want.

# DRAG-AND-DROP SUPPORT (Godot 4 style)
func _get_drag_data(_position):
	var drag_data = {"block_type": block_type, "display_text": display_text}
	# Show an icon preview or text preview
	var preview = Button.new()
	preview.text = display_text
	if ICONS.has(block_type):
		preview.icon = ICONS[block_type]
	set_drag_preview(preview)
	return drag_data

# RIGHT-CLICK TO REMOVE BLOCK (if inside AnswerArea)
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()
