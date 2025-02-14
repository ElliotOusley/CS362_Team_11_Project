extends HBoxContainer

@onready var CodeBlockScene = preload("res://Scenes/CodeBlock.tscn")

func _ready():
	# This ensures we receive drop events
	mouse_filter = Control.MOUSE_FILTER_PASS

func can_drop_data(_position, data):
	return data is Dictionary and data.has("block_type") and data.has("display_text")

func drop_data(_position, data):
	if data.has("block_type") and data.has("display_text"):
		var new_block = CodeBlockScene.instantiate()
		new_block.block_type = data["block_type"]
		new_block.display_text = data["display_text"]
		new_block.text = data["display_text"]
		add_child(new_block)
