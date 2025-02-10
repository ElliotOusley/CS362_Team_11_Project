# Scripts/PuzzleArea.gd
extends Area2D

@export var puzzle_available_blocks: Array = [
	{"block_type": "move_forward", "display_text": "Move Forward"},
	{"block_type": "turn_left", "display_text": "Turn Left"}
]

@export var puzzle_instructions: String = "Arrange blocks to navigate the maze: Move Forward, Turn Left, Move Forward."
@export var puzzle_expected_solution: Array = ["move_forward", "turn_left", "move_forward"]

# Load the PuzzleUI scene
var PuzzleUIScene = preload("res://Scenes/PuzzleUI.tscn")

func _ready():
	# Ensure signal is not connected multiple times
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Collision detected with:", body.name)
	
	if body.name == "Player":
		# Check if a PuzzleUI instance already exists and remove it
		var existing_puzzle_ui = get_tree().root.find_child("PuzzleUI", true, false)
		if existing_puzzle_ui:
			existing_puzzle_ui.queue_free()
		
		# Instance a new PuzzleUI
		var puzzle_instance = PuzzleUIScene.instantiate()
		puzzle_instance.name = "PuzzleUI"
		puzzle_instance.process_mode = Node.PROCESS_MODE_ALWAYS
		puzzle_instance.available_blocks = puzzle_available_blocks
		puzzle_instance.instructions_text = puzzle_instructions
		puzzle_instance.expected_solution = puzzle_expected_solution
		puzzle_instance.z_index = 100  # Ensure it renders on top
		get_tree().current_scene.add_child(puzzle_instance)

		# Pause the game
		get_tree().paused = true
		print("⏸️ Game paused while solving the puzzle.")

		# Connect signal to unpause when the puzzle is closed
		puzzle_instance.tree_exiting.connect(_on_puzzle_closed)

		# Disable further triggering
		set_deferred("monitoring", false)

# Unpause the game when PuzzleUI is closed
func _on_puzzle_closed():
	get_tree().paused = false
	print("▶️ Game unpaused after puzzle closed.")
