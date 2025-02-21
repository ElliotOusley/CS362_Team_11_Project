extends Control

@export var available_blocks: Array = [
	{ "block_type": "move_up", "display_text": "Move Up" },
	{ "block_type": "move_down", "display_text": "Move Down" },
	{ "block_type": "move_left", "display_text": "Move Left" },
	{ "block_type": "move_right", "display_text": "Move Right" }
]
@export var instructions_text: String = "Use the blocks to guide the Player to the Goal!"
@export var expected_solution: Array = []
@export var maze_index: int = 0

@onready var instructions_label = $CanvasLayer/Panel/VBoxContainer/InstructionsLabel
@onready var palette = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/Palette
@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/AnswerArea
@onready var submit_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SubmitButton
@onready var run_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/RunButton
@onready var message_label = $CanvasLayer/Panel/VBoxContainer/MessageLabel
@onready var maze_board_holder = $CanvasLayer/Panel/VBoxContainer/MazeBoardHolder
@onready var exit_button = $CanvasLayer/Panel/ExitButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("🟢 PuzzleUI Ready")
	instructions_label.text = instructions_text

	# Add the "Start" block to the AnswerArea so the user sees a starting block.
	var start_block = preload("res://Scenes/Item.tscn").instantiate()
	start_block.block_type = "start"
	answer_area.add_child(start_block)

	# Create the palette blocks
	for block_data in available_blocks:
		var item_instance = preload("res://Scenes/Item.tscn").instantiate()
		item_instance.block_type = block_data["block_type"]
		palette.add_child(item_instance)

	submit_button.pressed.connect(_on_SubmitButton_pressed)
	run_button.pressed.connect(_on_RunButton_pressed)

	exit_button.pressed.connect(_on_ExitButton_pressed)
	
	# Instantiate the MazeBoard
	var maze_board_instance = preload("res://Scenes/MazeBoard.tscn").instantiate()
	# Make sure to set the maze index so it loads the correct puzzle!
	maze_board_instance.maze_index = maze_index

	call_deferred("_add_maze_board", maze_board_instance)

func _add_maze_board(maze_board_instance):
	maze_board_holder.add_child(maze_board_instance)
	print("✅ MazeBoard successfully added with index =", maze_index)

func _on_ExitButton_pressed():
	print("🚪 Exiting PuzzleUI...")
	queue_free()  
	get_tree().paused = false  


func _on_SubmitButton_pressed():
	var solution = []
	# Gather block_types from each child in answer_area
	for item in answer_area.get_children():
		# The "start" block has block_type = "start", but skip it if you don't want it in solution
		# If you want to consider "start" as part of the solution, keep it in.
		if item.has_meta("block_type"):
			var block_t = item.get_meta("block_type")
			if block_t != "start":  # skip "start" block or keep it, up to you
				solution.append(block_t)

	if solution == expected_solution:
		message_label.text = "Correct! Puzzle solved."
		await get_tree().create_timer(2).timeout
		_close_puzzle()
	else:
		message_label.text = "Incorrect! Try again."
		await get_tree().create_timer(1).timeout
		_clear_answer_area()

func _close_puzzle():
	queue_free()

func _clear_answer_area():
	for item in answer_area.get_children():
		# Keep the "start" block so the user always sees it.
		if item.has_meta("block_type") and item.get_meta("block_type") == "start":
			continue
		item.queue_free()

func _on_RunButton_pressed():
	var commands = []
	for item in answer_area.get_children():
		if item.has_meta("block_type"):
			var b = item.get_meta("block_type")
			# skip "start" block
			if b != "start":
				commands.append(b)
		else:
			print("⚠️ WARNING: Dropped item does not contain a block_type!")

	var maze_board = maze_board_holder.get_child(0)
	if maze_board == null:
		message_label.text = "No maze loaded."
		return

	_execute_commands_on_maze(commands, maze_board)

func _execute_commands_on_maze(commands: Array, maze_board: Node2D) -> void:
	print("🔍 Checking nodes in MazeBoard...")

	var tilemap_layer = maze_board.get_node_or_null("TileMapLayer1") as TileMapLayer
	var walls_layer = maze_board.get_node_or_null("TileMapLayer2") as TileMapLayer
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var goal = maze_board.get_node_or_null("Goal") as CharacterBody2D

	print("📌 tilemap_layer: ", tilemap_layer)
	print("📌 walls_layer: ", walls_layer)
	print("📌 player: ", player)
	print("📌 goal: ", goal)

	if tilemap_layer == null or walls_layer == null or player == null or goal == null:
		print("❌ ERROR: One or more required nodes are missing in MazeBoard!")
		message_label.text = "Maze not set up properly."
		return

	# ✅ Convert player's position to tile coordinates using TileMapLayer
	var tile_size = Vector2(32, 32)  # Adjust based on your tileset size
	var player_tile = Vector2i(player.position / tile_size)

	var i = 0
	while i < commands.size():
		var cmd = commands[i]
		match cmd:
			"move_up", "move_down", "move_left", "move_right":
				player_tile = _move_player(player_tile, cmd, tilemap_layer, walls_layer)
				i += 1
			"for_3_times", "for_2_times":
				var repeats = 3 if cmd == "for_3_times" else 2
				if i + 1 < commands.size():
					var next_cmd = commands[i + 1]
					for rep in range(repeats):
						player_tile = _move_player(player_tile, next_cmd, tilemap_layer, walls_layer)
					i += 2
				else:
					i += 1
			"if_wall_ahead":
				if i + 1 < commands.size():
					var conditional_cmd = commands[i + 1]
					if _is_wall_ahead(player_tile, conditional_cmd, walls_layer):
						i += 2  # Skip the next command
					else:
						player_tile = _move_player(player_tile, conditional_cmd, tilemap_layer, walls_layer)
						i += 2
				else:
					i += 1
			_:
				i += 1

	# ✅ Convert tile position back to world position
	player.position = Vector2(player_tile) * tile_size + tile_size / 2

	# ✅ Check if the player reached the goal
	var goal_tile = Vector2i(goal.position / tile_size)
	if player_tile == goal_tile:
		message_label.text = "You reached the goal!"
	else:
		message_label.text = "You ended on tile %s" % str(player_tile)


func _move_player(current_tile: Vector2i, cmd: String, tilemap_layer: TileMapLayer, walls_layer: TileMapLayer) -> Vector2i:
	var next_tile = current_tile
	var player = maze_board_holder.get_child(0).get_node("Player")
	var animation_player = player.get_node_or_null("AnimationPlayer")  # ✅ Get AnimationPlayer inside Player

	match cmd:
		"move_up":
			next_tile.y -= 1
			if animation_player:
				animation_player.play("walk_up")  # Play walking up animation
		"move_down":
			next_tile.y += 1
			if animation_player:
				animation_player.play("walk_down")  # Play walking down animation
		"move_left":
			next_tile.x -= 1
			if animation_player:
				animation_player.play("walk_left")  # Play walking left animation
		"move_right":
			next_tile.x += 1
			if animation_player:
				animation_player.play("walk_right")  # Play walking right animation
		_:
			pass

	# If a wall is in the way, stop animation and return current position
	if _is_wall(walls_layer, next_tile):
		if animation_player:
			animation_player.stop()
		return current_tile

	return next_tile  # Move to the new position if no wall is there



func _is_wall(walls_layer: TileMapLayer, tile_coords: Vector2i) -> bool:
	# ✅ Correct usage: get_cell_atlas_coords() takes only the tile position
	return walls_layer.get_cell_atlas_coords(tile_coords) != Vector2i(-1, -1)

func _is_wall_ahead(current_tile: Vector2i, cmd: String, walls_layer: TileMapLayer) -> bool:
	var check_tile = current_tile

	match cmd:
		"move_up":
			check_tile.y -= 1
		"move_down":
			check_tile.y += 1
		"move_left":
			check_tile.x -= 1
		"move_right":
			check_tile.x += 1
		_:
			pass

	return _is_wall(walls_layer, check_tile)
