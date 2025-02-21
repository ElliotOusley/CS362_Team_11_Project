extends MarginContainer

@export var block_type: String = ""
@export var modulation := Color(1, 1, 1, 1) :
	get:
		return modulation
	set(value):
		modulation = value
		%TextureRect.modulate = value  # ✅ Apply modulation to existing TextureRect

@onready var ICONS := {
	"move_up": preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down": preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left": preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png"),

	# Optional: If you have other block types like "if_wall_ahead", "for_2_times", etc., 
	# be sure to define them here with some default icon.
	#"if_wall_ahead": preload("res://Sprites/CodeBlockSprites/ifWall.png"),
	#"for_2_times": preload("res://Sprites/CodeBlockSprites/loop2x.png"),
	#"for_3_times": preload("res://Sprites/CodeBlockSprites/loop3x.png"),
	# Provide a custom icon for "start" if you wish.
	"start": preload("res://Sprites/CodeBlockSprites/start.png"),
}

func _ready():
	# Ensure block_type is valid
	if block_type not in ICONS:
		print("❌ ERROR: Invalid block_type:", block_type, " | Defaulting to 'move_up'")
		block_type = "move_up"

	# Set correct icon
	%TextureRect.texture = ICONS[block_type]

func _get_drag_data(_position):
	var preview = Control.new()
	var icon = TextureRect.new()

	# ✅ Get texture from existing TextureRect
	icon.texture = %TextureRect.texture  
	icon.position = icon.texture.get_size() * -0.5
	icon.modulate = modulation  # ✅ Keep modulation

	preview.add_child(icon)
	preview.z_index = 60

	set_drag_preview(preview)  # ✅ Set preview
	return { 
		"block_type": block_type,
		"texture": %TextureRect.texture,  # ✅ Ensure texture is included
		"modulation": modulation  # ✅ Include modulation in drag data
	}

# --------------------------------------------------
# ✅ Allow Right-Click to Remove from AnswerArea
# --------------------------------------------------
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent() and get_parent().name == "AnswerArea":
			# Do not allow removing "start" block if you want that pinned:
			if block_type == "start":
				return
			queue_free()  # Removes the block from AnswerArea
