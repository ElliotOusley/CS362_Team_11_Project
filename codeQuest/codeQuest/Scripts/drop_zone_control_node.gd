extends Panel

@onready var ICONS := {
    "move_up": preload("res://Sprites/CodeBlockSprites/moveUp.png"),
    "move_down": preload("res://Sprites/CodeBlockSprites/moveDown.png"),
    "move_left": preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
    "move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png")
}

func _ready():
    print("DropZoneControl READY. I'm a Panel for dropping items.")

func _can_drop_data(at_position, data):
    print("DropZoneControl _can_drop_data called with data:", data)
    return data is Dictionary and data.has("block_type") and data.has("texture")

func _drop_data(at_position, data):
    print("DropZoneControl _drop_data called with data:", data)

    if not (data is Dictionary and data.has("texture") and data.has("block_type")):
        print("❌ ERROR: Dropped item does not contain a valid texture or block_type!")
        return

    var component = TextureRect.new()
    component.texture = data["texture"]
    component.modulate = data.get("modulation", Color(1, 1, 1, 1))
    component.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
    component.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    component.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    component.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    component.custom_minimum_size = Vector2(50, 50)
    component.set_meta("block_type", data["block_type"])
    component.position = at_position - (component.custom_minimum_size * 0.5)
    add_child(component)
    print("✅ Dropped item in DropZoneControl at pos:", at_position)

