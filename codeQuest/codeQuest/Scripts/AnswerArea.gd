# Scripts/AnswerArea.gd
extends HBoxContainer

# Preload the CodeBlock scene (Make sure the file exists!)
@onready var CodeBlockScene = preload("res://Scenes/CodeBlock.tscn")

# Allow dropping blocks
func can_drop_data(_position, data):
	return data is Dictionary and data.has("block_type") and data.has("display_text")

# Handle dropping a block
func drop_data(_position, data):
	if data.has("block_type") and data.has("display_text"):
		var new_block = CodeBlockScene.instantiate()
		new_block.block_type = data["block_type"]
		new_block.display_text = data["display_text"]
		new_block.text = data["display_text"]
		add_child(new_block)
