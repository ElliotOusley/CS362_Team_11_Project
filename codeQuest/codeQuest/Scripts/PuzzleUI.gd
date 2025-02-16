extends Control

@export var available_blocks: Array = [
	{ "block_type": "move_up", "display_text": "Move Up" },
	{ "block_type": "move_down", "display_text": "Move Down" },
	{ "block_type": "move_left", "display_text": "Move Left" },
	{ "block_type": "move_right", "display_text": "Move Right" }
]
@export var instructions_text: String = "Use the blocks to guide the Player to the Goal!"
@export var expected_solution: Array = []  # e.g., [ "move_up", "move_up", "move_right", "move_right" ]
@export var maze_index: int = 0  # Which maze to load (0..9)

@onready var instructions_label = $CanvasLayer/Panel/VBoxContainer/InstructionsLabel
@onready var palette = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/Palette
@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/AnswerArea
@onready var submit_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SubmitButton
@onready var run_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/RunButton
@onready var message_label = $CanvasLayer/Panel/VBoxContainer/MessageLabel
@onready var maze_board_holder = $CanvasLayer/Panel/VBoxContainer/MazeBoardHolder

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("🟢 PuzzleUI Ready")
	instructions_label.text = instructions_text

	# Create palette items from available_blocks.
	for block_data in available_blocks:
		var item_instance = preload("res://Scenes/Item.tscn").instantiate()
		item_instance.block_type = block_data["block_type"]
		palette.add_child(item_instance)

	# Connect buttons.
	submit_button.pressed.connect(_on_SubmitButton_pressed)
	run_button.pressed.connect(_on_RunButton_pressed)

	# Load and add the MazeBoard scene.
	var MazeBoardScene = preload("res://Scenes/MazeBoard.tscn")
	var maze_board_instance = MazeBoardScene.instantiate()
	# Defer adding to avoid physics timing issues.
	call_deferred("_add_maze_board", maze_board_instance)

func _add_maze_board(maze_board_instance):
	maze_board_holder.add_child(maze_board_instance)
	print("✅ MazeBoard successfully added!")

func _on_SubmitButton_pressed():
	# Gather block_types from items dropped into AnswerArea.
	var solution = []
	for item in answer_area.get_children():
		solution.append(item.block_type)
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
		item.queue_free()

func _on_RunButton_pressed():
	var commands = []
	
	# ✅ Use get_meta("block_type") for TextureRects
	for item in answer_area.get_children():
		if item.has_meta("block_type"):  # ✅ Check if metadata exists
			commands.append(item.get_meta("block_type"))
		else:
			print("⚠️ WARNING: Dropped item does not contain a block_type!")

	var maze_board = maze_board_holder.get_child(0)
	if maze_board == null:
		message_label.text = "No maze loaded."
		return

	_execute_commands_on_maze(commands, maze_board)


func _execute_commands_on_maze(commands: Array, maze_board: Node2D) -> void:
	var tilemap = maze_board.get_node_or_null("TileMapLayer1") as TileMap
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var goal = maze_board.get_node_or_null("Goal") as Sprite2D
	if tilemap == null or player == null or goal == null:
		message_label.text = "Maze not set up properly."
		return
	var tile_size = tilemap.tile_set.tile_size
	var player_tile = tilemap.local_to_map(player.position)
	var i = 0
	while i < commands.size():
		var cmd = commands[i]
		match cmd:
			"move_up", "move_down", "move_left", "move_right":
				player_tile = _move_player(player_tile, cmd, tilemap)
				i += 1
			"for_3_times", "for_2_times":
				if i + 1 < commands.size():
					var next_cmd = commands[i + 1]
					var repeats = 3 if cmd == "for_3_times" else 2
					for rep in range(repeats):
						player_tile = _move_player(player_tile, next_cmd, tilemap)
					i += 2
				else:
					i += 1
			"if_wall_ahead":
				if i + 1 < commands.size():
					var conditional_cmd = commands[i + 1]
					if _is_wall_ahead(player_tile, conditional_cmd, tilemap):
						i += 2
					else:
						player_tile = _move_player(player_tile, conditional_cmd, tilemap)
						i += 2
				else:
					i += 1
			_:
				i += 1
	player.position = tilemap.map_to_local(player_tile) + Vector2(tile_size) / 2
	var goal_tile = tilemap.local_to_map(goal.position)
	if player_tile == goal_tile:
		message_label.text = "You reached the goal!"
	else:
		message_label.text = "You ended on tile %s" % str(player_tile)

func _move_player(current_tile: Vector2i, cmd: String, tilemap: TileMap) -> Vector2i:
	var next_tile = current_tile
	match cmd:
		"move_up":
			next_tile.y -= 1
		"move_down":
			next_tile.y += 1
		"move_left":
			next_tile.x -= 1
		"move_right":
			next_tile.x += 1
		_:
			pass
	if _is_wall(tilemap, next_tile):
		return current_tile
	return next_tile

func _is_wall(tilemap: TileMap, tile_coords: Vector2i) -> bool:
	var cell_id = tilemap.get_cell(0, tile_coords)
	return cell_id == 1

func _is_wall_ahead(current_tile: Vector2i, cmd: String, tilemap: TileMap) -> bool:
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
	return _is_wall(tilemap, check_tile)
