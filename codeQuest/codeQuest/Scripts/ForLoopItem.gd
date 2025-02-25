extends MarginContainer

@export var block_type: String = "for_loop"
@export var modulation := Color(1, 1, 1, 1) :
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
@onready var label_node: Label = $VBoxContainer/HeaderHBox/Label
@onready var icon_rect: TextureRect = $VBoxContainer/HeaderHBox/TextureRect

@onready var ICONS: Dictionary = {
	"for_loop": preload("res://Sprites/CodeBlockSprites/forLoop.png")
}

func _ready():
	if label_node:
		label_node.text = "FOR Loop"
	else:
		push_error("❌ Label node not found in ForLoopItem scene!")
	
	if icon_rect:
		if ICONS.has(block_type):
			icon_rect.texture = ICONS[block_type]
			icon_rect.modulate = modulation
		else:
			push_warning("⚠️ Unknown block_type: " + block_type)
	else:
		push_error("❌ TextureRect not found in ForLoopItem scene!")

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
	set_drag_preview(preview)
	return {
		"block_type": block_type,
		"texture": icon_rect.texture
	}

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			queue_free()
