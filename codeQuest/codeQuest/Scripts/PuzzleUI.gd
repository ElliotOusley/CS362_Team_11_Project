# Scripts/PuzzleUI.gd
extends Control

# Variables set by the PuzzleArea when instancing this UI
@export var available_blocks: Array = []
@export var instructions_text: String = ""
@export var expected_solution: Array = []

# Cache references to UI elements
@onready var instructions_label = $Panel/VBoxContainer/InstructionsLabel
@onready var palette = $Panel/VBoxContainer/Palette
@onready var answer_area = $Panel/VBoxContainer/AnswerArea
@onready var submit_button = $Panel/VBoxContainer/SubmitButton
@onready var message_label = $Panel/VBoxContainer/MessageLabel

func _ready():
	# Set instructions text
	instructions_label.text = instructions_text

	# Populate the palette with available blocks
	for block_data in available_blocks:
		var block_instance = preload("res://Scenes/CodeBlock.tscn").instantiate()
		block_instance.block_type = block_data["block_type"]
		block_instance.display_text = block_data["display_text"]
		block_instance.text = block_data["display_text"]
		palette.add_child(block_instance)

	# Connect the Submit button
	submit_button.pressed.connect(_on_SubmitButton_pressed)

# Called when Submit is pressed
func _on_SubmitButton_pressed():
	var solution = []
	# Collect the block_type from each child in AnswerArea
	for block in answer_area.get_children():
		solution.append(block.block_type)

	# Compare to expected answer
	if solution == expected_solution:
		message_label.text = "Correct! Puzzle solved."
		await get_tree().create_timer(2).timeout  # Replaced yield with await
		queue_free()
	else:
		message_label.text = "Incorrect! Try again."
		await get_tree().create_timer(1).timeout  # Replaced yield with await
		_clear_answer_area()

func _clear_answer_area():
	for block in answer_area.get_children():
		block.queue_free()
