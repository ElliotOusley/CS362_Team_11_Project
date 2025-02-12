extends Control

@export var available_blocks: Array = []
@export var instructions_text: String = ""
@export var expected_solution: Array = []

@onready var instructions_label = $CanvasLayer/Panel/VBoxContainer/InstructionsLabel
@onready var palette = $CanvasLayer/Panel/VBoxContainer/Palette
@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/AnswerArea
@onready var submit_button = $CanvasLayer/Panel/VBoxContainer/SubmitButton
@onready var message_label = $CanvasLayer/Panel/VBoxContainer/MessageLabel

func _ready():
	instructions_label.text = instructions_text

	for block_data in available_blocks:
		var block_instance = preload("res://Scenes/CodeBlock.tscn").instantiate()
		block_instance.block_type = block_data["block_type"]
		block_instance.display_text = block_data["display_text"]
		block_instance.text = block_data["display_text"]
		palette.add_child(block_instance)

	submit_button.pressed.connect(_on_SubmitButton_pressed)

# Handles submit button
func _on_SubmitButton_pressed():
	var solution = []
	for block in answer_area.get_children():
		solution.append(block.block_type)

	if solution == expected_solution:
		message_label.text = "Correct! Puzzle solved."
		await get_tree().create_timer(2).timeout
		_close_puzzle()
	else:
		message_label.text = "Incorrect! Try again."
		await get_tree().create_timer(1).timeout
		_clear_answer_area()

# Close puzzle UI and unpause game
func _close_puzzle():
	queue_free()  # This removes the UI from the scene, triggering _on_puzzle_closed in PuzzleArea.gd

func _clear_answer_area():
	for block in answer_area.get_children():
		block.queue_free()
