extends MarginContainer

@export var modulation: Color = Color(1, 1, 0.5, 1)

func _ready():
	var color_rect = $ColorRect
	color_rect.color = modulation

func _get_drag_data(_position):
	var drag_data = {
		"item_id": "godot_icon",
		"modulation": modulation
	}
	var preview = Control.new()
	preview.z_index = 60

	var icon = TextureRect.new()
	icon.texture = load("res://icon.svg")  # Example icon
	icon.position = icon.texture.get_size() * -0.5
	icon.modulate = modulation

	preview.add_child(icon)
	set_drag_preview(preview)
	print("Dragging item with data:", drag_data)
	return drag_data
