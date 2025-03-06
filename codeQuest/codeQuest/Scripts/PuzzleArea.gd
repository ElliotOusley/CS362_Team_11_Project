extends Area2D

@export var puzzle_id: int = 0

# A dictionary containing each puzzle's data, including:
#  - instructions: A description of what the puzzle is about.
#  - blocks: A list of available blocks to solve the puzzle.
#  - expected_solution: The correct sequence of blocks to solve the puzzle.
#  - maze_index: The index representing the specific maze or layout for this puzzle.
var PUZZLES = [
	{
		"instructions": "Puzzle 0 - Basic Movement: Use the basic movement blocks to reach the goal.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"}
		],
		"expected_solution": ["move_right", "move_right"],  # Expected: Move right twice.
		"maze_index": 0
	},
	{
		"instructions": "Puzzle 1 - Watch out for walls! Use movement and conditional blocks to avoid walls.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"}
		],
		"expected_solution": ["move_left", "if_wall_ahead", "move_left", "move_up"],  # Expected: Move left, handle wall, move left, and move up.
		"maze_index": 1
	},
	{
		"instructions": "Puzzle 2 - Try loops! Use loops to repeat actions.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["for_3_times", "move_right"],  # Expected: Repeat move right 3 times.
		"maze_index": 2
	},
	{
		"instructions": "Puzzle 3 - Combine loops & if! Combine looping and conditional blocks.",
		"blocks": [ 
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"}
		],
		"expected_solution": ["if_wall_ahead", "move_right", "for_2_times", "move_down"],  # Expected: Check wall, move right, repeat move down twice.
		"maze_index": 3
	},
	{
		"instructions": "Puzzle 4 - Diagonal walls: Navigate around diagonal walls.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["move_right", "move_right", "move_up", "move_up"],  # Expected: Move right twice, move up twice.
		"maze_index": 4
	},
	{
		"instructions": "Puzzle 5 - Spiral walls: Navigate around spiral walls.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["move_right", "if_wall_ahead", "move_down"],  # Expected: Move right, handle wall, move down.
		"maze_index": 5
	},
	{
		"instructions": "Puzzle 6: Use loops and conditionals to navigate.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["move_down", "move_right", "move_right"],  # Expected: Move down, move right twice.
		"maze_index": 6
	},
	{
		"instructions": "Puzzle 7 - More advanced walls: Handle advanced wall conditions.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["for_3_times", "move_right"],  # Expected: Repeat move right 3 times.
		"maze_index": 7
	},
	{
		"instructions": "Puzzle 8 - Corridors: Navigate through corridors using basic movement.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["move_right", "move_right", "move_right"],  # Expected: Move right 3 times.
		"maze_index": 8
	},
	{
		"instructions": "Puzzle 9 - Complex perimeter and center walls: Navigate around complex walls.",
		"blocks": [
			{"block_type": "move_up", "display_text": "Move Up"},
			{"block_type": "move_down", "display_text": "Move Down"},
			{"block_type": "move_left", "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		],
		"expected_solution": ["for_2_times", "move_right", "move_down"],  # Expected: Repeat move right twice, then move down.
		"maze_index": 9
	},
]

var PuzzleUIScene = preload("res://Scenes/PuzzleUI.tscn")

func _ready():
	# Connect body_entered signal to handle puzzle interactions.
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		# Check if there's an existing puzzle UI; if so, remove it.
		var existing_puzzle_ui = get_tree().root.find_child("PuzzleUI", true, false)
		if existing_puzzle_ui:
			existing_puzzle_ui.queue_free()

		# Get the puzzle data for the selected puzzle_id.
		if puzzle_id < 0 or puzzle_id >= PUZZLES.size():
			puzzle_id = 0  # Default to Puzzle 0 if the ID is invalid.

		var puzzle_data = PUZZLES[puzzle_id]

		# Instantiate and set up the puzzle UI with the current puzzle's data.
		var puzzle_instance = PuzzleUIScene.instantiate()
		puzzle_instance.name = "PuzzleUI"
		puzzle_instance.process_mode = Node.PROCESS_MODE_ALWAYS

		# Set puzzle data like available blocks, instructions, and expected solution.
		puzzle_instance.available_blocks = puzzle_data["blocks"]
		puzzle_instance.instructions_text = puzzle_data["instructions"]
		puzzle_instance.expected_solution = puzzle_data["expected_solution"]
		puzzle_instance.maze_index = puzzle_data["maze_index"]

		# Add the puzzle UI to the current scene.
		get_tree().current_scene.add_child(puzzle_instance)

		# Pause the game so the player can't move during the puzzle.
		get_tree().paused = true
		puzzle_instance.tree_exiting.connect(_on_puzzle_closed)
		set_deferred("monitoring", false)  # Prevent re-triggering.

func _on_puzzle_closed():
	# Unpause the game once the puzzle is closed.
	get_tree().paused = false
