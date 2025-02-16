extends Button

@export var block_type: String = ""
@export var display_text: String = ""

@onready var ICONS := {
	"move_up":    preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down":  preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left":  preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png")
	# Add more if you have other commands
}

func _ready():
	text = display_text
	z_index = 10
	mouse_filter = Control.MOUSE_FILTER_STOP
	if ICONS.has(block_type):
		icon = ICONS[block_type] as Texture2D
		expand_icon = true
		icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _get_drag_data(at_position):
	var drag_data = {
		"block_type": block_type,
		"display_text": display_text
	}
	print("🟢 Dragging block:", drag_data)

	# Create a drag preview
	var preview = Button.new()
	preview.z_index = 100
	preview.text = display_text
	if ICONS.has(block_type):
		preview.icon = ICONS[block_type]
		preview.expand_icon = true
		preview.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

	set_drag_preview(preview)
	return drag_data

func _gui_input(event):
	# Right-click to remove from AnswerArea
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()
