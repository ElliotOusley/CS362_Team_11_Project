extends MarginContainer

@export var block_type: String = "for_loop"
@export var modulation := Color(1,1,1,1):
	get:
		return modulation
	set(value):
		modulation = value
		%TextureRect.modulate = value  # Apply modulation to existing TextureRect

func set_modulation(value: Color) -> void:
	modulation = value
	if icon_rect:
		icon_rect.modulate = value

@onready var spin_box: SpinBox = $VBoxContainer/HeaderHBox/SpinBox
@onready var label_node: Label = $VBoxContainer/HeaderHBox/Label  # Ensure this exists
@onready var icon_rect: TextureRect = $VBoxContainer/HeaderHBox/TextureRect

@onready var ICONS: Dictionary = {
	"for_loop": preload("res://Sprites/CodeBlockSprites/forLoop.png")
}

func _ready():
	if not label_node:
		push_error("❌ Label node not found in ForLoopItem scene!")
		return

	if not spin_box:
		push_error("❌ SpinBox node not found in ForLoopItem scene!")
		return

	if icon_rect:
		if ICONS.has(block_type):
			icon_rect.texture = ICONS[block_type]
			icon_rect.modulate = modulation
		else:
			push_warning("⚠️ Unknown block_type: " + block_type)
	else:
		push_error("❌ TextureRect not found in ForLoopItem scene!")

	# Connect spinbox changes to update label
	spin_box.value_changed.connect(_on_spin_box_value_changed)

	# Update label on start
	_on_spin_box_value_changed(spin_box.value)

func get_loop_count() -> int:
	return int(spin_box.value)

func get_block_container() -> VBoxContainer:
	return $VBoxContainer/BlockContainer

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

	# Add label showing loop count in the preview
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
		"loop_count": get_loop_count()  # Include loop count in drag data
	}

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()

# **Fix: Properly updates label on SpinBox change**
func _on_spin_box_value_changed(value: float) -> void:
	if label_node:
		label_node.text = "FOR %d times" % int(value)
	else:
		push_error("❌ label_node is NULL! Ensure it is assigned correctly in ForLoopItem scene.")
