extends Control

@export var available_blocks: Array = []
@export var instructions_text: String = ""
@export var expected_solution: Array = []
@export var maze_index: int = 0  # <--- which maze to load

@onready var instructions_label = $CanvasLayer/Panel/VBoxContainer/InstructionsLabel
@onready var palette = $CanvasLayer/Panel/VBoxContainer/Palette
@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/AnswerArea
@onready var submit_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SubmitButton
@onready var run_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/RunButton
@onready var message_label = $CanvasLayer/Panel/VBoxContainer/MessageLabel

@onready var maze_board_holder = $CanvasLayer/MazeBoardHolder

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	instructions_label.text = instructions_text

	# Populate palette with blocks
	for block_data in available_blocks:
		var block_instance = preload("res://Scenes/CodeBlock.tscn").instantiate()
		block_instance.block_type = block_data["block_type"]
		block_instance.display_text = block_data["display_text"]
		block_instance.text = block_data["display_text"]
		palette.add_child(block_instance)

	# Connect submit and run
	submit_button.pressed.connect(_on_SubmitButton_pressed)
	run_button.pressed.connect(_on_RunButton_pressed)

	# Load MazeBoard
	var MazeBoardScene = preload("res://Scenes/MazeBoard.tscn")
	var maze_board_instance = MazeBoardScene.instantiate()
	# Set the correct maze_index
	maze_board_instance.maze_index = maze_index
	maze_board_holder.add_child(maze_board_instance)

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

func _close_puzzle():
	queue_free()  # triggers puzzle_area.gd to unpause

func _clear_answer_area():
	for block in answer_area.get_children():
		block.queue_free()

# ------------------------------------------------
#  RUN BUTTON: Interpret the blocks and move
#  the MazeBoard player accordingly.
# ------------------------------------------------
func _on_RunButton_pressed():
	var commands = []
	for block in answer_area.get_children():
		commands.append(block.block_type)

	var maze_board = maze_board_holder.get_child(0)
	if maze_board == null:
		message_label.text = "No maze loaded."
		return

	_execute_commands_on_maze(commands, maze_board)

func _execute_commands_on_maze(commands: Array, maze_board: Node2D) -> void:
	# We'll assume MazeBoard has references to tilemap, player, goal.
	# We'll do a very simplistic approach: 
	#    - If 'move_up', move the player up 1 tile
	#    - If 'move_down', move the player down 1 tile, 
	#    - etc.
	# For 'for_3_times', we look at the next command and repeat it 3 times. 
	# This is simplistic but demonstrates the concept.

	var tilemap = maze_board.get_node("TileMap") as TileMap
	var player = maze_board.get_node("Player") as Sprite2D
	var goal = maze_board.get_node("Goal") as Sprite2D
	
	if tilemap == null or player == null or goal == null:
		message_label.text = "Maze not set up properly."
		return

	# Convert player's current position to tile coords
	var tile_size = tilemap.tile_set.tile_size
	var player_tile = tilemap.world_to_map(player.position)

	# We'll parse the commands in a simple pass
	var i = 0
	while i < commands.size():
		var cmd = commands[i]

		match cmd:
			"move_forward", "move_up", "move_down", "move_left", "move_right":
				player_tile = _move_player(player_tile, cmd, tilemap)
				i += 1
			"for_3_times", "for_2_times":
				# We'll handle a mini-loop. We look at the next command and repeat it 2 or 3 times.
				if i + 1 < commands.size():
					var next_cmd = commands[i + 1]
					var repeats = 3 if cmd == "for_3_times" else 2
					for rep in range(repeats):
						player_tile = _move_player(player_tile, next_cmd, tilemap)
					i += 2  # skip the next command because we used it
				else:
					# There's no next command, so just skip
					i += 1
			"if_wall_ahead":
				# We'll check the next command only if there's no wall.
				# This is more advanced logic, but let's do a simple approach:
				if i + 1 < commands.size():
					var conditional_cmd = commands[i + 1]
					if _is_wall_ahead(player_tile, conditional_cmd, tilemap):
						# do nothing
						i += 2
					else:
						# execute the command
						player_tile = _move_player(player_tile, conditional_cmd, tilemap)
						i += 2
				else:
					i += 1
			_:
				# unknown command
				i += 1

	# After executing all commands, update the player's position
	player.position = tilemap.map_to_world(player_tile) + tile_size/2

	# Check if player is on the goal tile
	var goal_tile = tilemap.world_to_map(goal.position)
	if player_tile == goal_tile:
		message_label.text = "You reached the goal!"
	else:
		message_label.text = "You ended up at tile %s" % str(player_tile)

func _move_player(current_tile: Vector2i, cmd: String, tilemap: TileMap) -> Vector2i:
	var next_tile = current_tile
	match cmd:
		"move_forward", "move_up":
			next_tile.y -= 1
		"move_down":
			next_tile.y += 1
		"move_left":
			next_tile.x -= 1
		"move_right":
			next_tile.x += 1
		_:
			# unknown or no move
			pass

	# Check if next_tile is passable or a wall
	if _is_wall(tilemap, next_tile):
		# can't move there, stay in current_tile
		return current_tile
	else:
		return next_tile

func _is_wall(tilemap: TileMap, tile_coords: Vector2i) -> bool:
	# This function checks if the tile is a wall
	# For simplicity, let's say if it's tile ID 1, it's a wall.
	var cell_id = tilemap.get_cell(0, tile_coords)
	if cell_id == 1:
		return true
	return false

func _is_wall_ahead(current_tile: Vector2i, cmd: String, tilemap: TileMap) -> bool:
	var check_tile = current_tile
	match cmd:
		"move_up", "move_forward":
			check_tile.y -= 1
		"move_down":
			check_tile.y += 1
		"move_left":
			check_tile.x -= 1
		"move_right":
			check_tile.x += 1
		_:
			pass

	return _is_wall(tilemap, check_tile)
