extends MarginContainer

@export var block_type: String = "while_loop"
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

#@onready var label_node: Label = $VBoxContainer/HeaderHBox/Label
@onready var icon_rect: TextureRect = $VBoxContainer/HeaderHBox/TextureRect

@onready var ICONS: Dictionary = {
	"while_loop": preload("res://Sprites/CodeBlockSprites/whileLoop.png")
}

func _ready():
	#if label_node:
		#label_node.text = "WHILE No Wall"
	#else:
		#push_error("❌ Label node not found in WhileLoopItem scene!")
	
	if icon_rect:
		if ICONS.has(block_type):
			icon_rect.texture = ICONS[block_type]
			icon_rect.modulate = modulation
		else:
			push_warning("⚠️ Unknown block_type: " + block_type)
	else:
		push_error("❌ TextureRect not found in WhileLoopItem scene!")

func get_block_container() -> HBoxContainer:
	return $VBoxContainer/HeaderHBox/TextureRect/BlockContainer

func _get_drag_data(_position):
	if not icon_rect or not icon_rect.texture:
		push_error("❌ Missing icon texture in WhileLoopItem.")
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
