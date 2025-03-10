extends Area2D

@export var puzzle_id: int = 0

var PUZZLES = [
	{
		"instructions": "Puzzle 0 - Basic Movement",
		"blocks": [
			{"block_type": "move_up",    "display_text": "Move Up"},
			{"block_type": "move_down",  "display_text": "Move Down"},
			{"block_type": "move_left",  "display_text": "Move Left"},
			{"block_type": "move_right", "display_text": "Move Right"},
			{"block_type": "for_loop",   "display_text": "For Loop"},
			{"block_type": "while_loop", "display_text": "While Loop"}
		],
		"expected_solution": ["move_up","move_right"],
		"maze_index": 0
	}
]

var PuzzleUIScene = preload("res://Scenes/PuzzleUI.tscn")

func _ready():
	# Prevent double-connection if you also connected in the editor:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		var existing = get_tree().root.find_child("PuzzleUI", true, false)
		if existing:
			existing.queue_free()

		if puzzle_id < 0 or puzzle_id >= PUZZLES.size():
			puzzle_id = 0
		var puzzle_data = PUZZLES[puzzle_id]

		var puzzle_ui = PuzzleUIScene.instantiate()
		puzzle_ui.name = "PuzzleUI"
		puzzle_ui.available_blocks = puzzle_data["blocks"]
		puzzle_ui.instructions_text = puzzle_data["instructions"]
		puzzle_ui.expected_solution = puzzle_data["expected_solution"]
		puzzle_ui.maze_index = puzzle_data["maze_index"]
		get_tree().current_scene.add_child(puzzle_ui)

		get_tree().paused = true
		puzzle_ui.tree_exiting.connect(_on_puzzle_closed)

		# Instead of set_deferred("monitoring", false), do call_deferred
		call_deferred("_disable_monitoring")

func _disable_monitoring():
	monitoring = false

func _on_puzzle_closed():
	get_tree().paused = false
