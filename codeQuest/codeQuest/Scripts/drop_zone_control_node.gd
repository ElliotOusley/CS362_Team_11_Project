extends Panel

func _ready():
	print("DropZoneControl READY. I'm a Panel for dropping items.")

func _can_drop_data(at_position, data):
	print("DropZoneControl _can_drop_data called with data:", data)
	return data.has("item_id") and data["item_id"] == "godot_icon"

func _drop_data(at_position, data):
	print("DropZoneControl _drop_data called with data:", data)
	var component = TextureRect.new()
	component.texture = load("res://icon.svg")
	component.modulate = data["modulation"] if data.has("modulation") else Color.WHITE
	component.position = at_position - (component.texture.get_size() * 0.5)
	add_child(component)
	print("✅ Dropped item in DropZoneControl at pos:", at_position)
