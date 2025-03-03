#extends Area2D
#
#@export var puzzle_id: int = 0
#
## We'll define a dictionary for each puzzle with:
##  - instructions
##  - blocks
##  - expected_solution
##  - maze_index
#var PUZZLES = [
	#{
		#"instructions": "Puzzle 0 - Basic Movement",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"}
		#],
		#"expected_solution": ["move_right", "move_right"],
		#"maze_index": 0
	#},
	#{
		#"instructions": "Puzzle 1 - Watch out for walls!",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"}
		#],
		#"expected_solution": ["move_left","if_wall_ahead","move_left","move_up"],
		#"maze_index": 1
	#},
	#{
		#"instructions": "Puzzle 2 - Try loops!",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["for_3_times","move_right"],
		#"maze_index": 2
	#},
	#{
		#"instructions": "Puzzle 3 - Combine loops & if!",
		#"blocks": [ 
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"}
		#],
		#"expected_solution": ["if_wall_ahead","move_right","for_2_times","move_down"],
		#"maze_index": 3
	#},
	#{
		#"instructions": "Puzzle 4 - Diagonal walls",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["move_right","move_right","move_up","move_up"],
		#"maze_index": 4
	#},
	#{
		#"instructions": "Puzzle 5 - Spiral walls",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			#{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["move_right","if_wall_ahead","move_down"],
		#"maze_index": 5
	#},
	#{
		#"instructions": "Puzzle 6",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			#{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["move_down","move_right","move_right"],
		#"maze_index": 6
	#},
	#{
		#"instructions": "Puzzle 7 - More advanced walls",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["for_3_times","move_right"],
		#"maze_index": 7
	#},
	#{
		#"instructions": "Puzzle 8 - Corridors",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			#{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["move_right","move_right","move_right"],
		#"maze_index": 8
	#},
	#{
		#"instructions": "Puzzle 9 - Complex perimeter and center walls",
		#"blocks": [
			#{"block_type": "move_up", "display_text": "Move Up"},
			#{"block_type": "move_down", "display_text": "Move Down"},
			#{"block_type": "move_left", "display_text": "Move Left"},
			#{"block_type": "move_right", "display_text": "Move Right"},
			#{"block_type": "if_wall_ahead", "display_text": "If Wall Ahead, Skip Next"},
			#{"block_type": "for_2_times", "display_text": "Repeat Next (2x)"},
			#{"block_type": "for_3_times", "display_text": "Repeat Next (3x)"}
		#],
		#"expected_solution": ["for_2_times","move_right","move_down"],
		#"maze_index": 9
	#},
#]
#
#var PuzzleUIScene = preload("res://Scenes/PuzzleUI.tscn")
#
#func _ready():
	## Connect body_entered if not already
	#if not body_entered.is_connected(_on_body_entered):
		#body_entered.connect(_on_body_entered)
#
#func _on_body_entered(body):
	#if body.name == "Player":
		#var existing_puzzle_ui = get_tree().root.find_child("PuzzleUI", true, false)
		#if existing_puzzle_ui:
			#existing_puzzle_ui.queue_free()
#
		## Get the puzzle data for puzzle_id
		#if puzzle_id < 0 or puzzle_id >= PUZZLES.size():
			#puzzle_id = 0
#
		#var puzzle_data = PUZZLES[puzzle_id]
#
		#var puzzle_instance = PuzzleUIScene.instantiate()
		#puzzle_instance.name = "PuzzleUI"
		#puzzle_instance.process_mode = Node.PROCESS_MODE_ALWAYS
#
		#puzzle_instance.available_blocks = puzzle_data["blocks"]
		#puzzle_instance.instructions_text = puzzle_data["instructions"]
		#puzzle_instance.expected_solution = puzzle_data["expected_solution"]
		#puzzle_instance.maze_index = puzzle_data["maze_index"]
#
		#get_tree().current_scene.add_child(puzzle_instance)
#
		## Pause the game so player can't move
		#get_tree().paused = true
		#puzzle_instance.tree_exiting.connect(_on_puzzle_closed)
		#set_deferred("monitoring", false)  # so we don't trigger again
#
#func _on_puzzle_closed():
	#get_tree().paused = false


extends Area2D

@export var puzzle_id: int = 0

var PUZZLES = [
	{
		"instructions": "Puzzle 0 - Basic Movement",
		"blocks": [
			{"block_type": "start", "display_text": "Start"},
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
