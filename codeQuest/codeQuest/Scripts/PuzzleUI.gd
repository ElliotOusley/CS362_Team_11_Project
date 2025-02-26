extends Control

@export var available_blocks: Array = []
@export var instructions_text: String = ""
@export var expected_solution: Array = []
@export var maze_index: int = 0

@onready var instructions_label = $CanvasLayer/Panel/InstructionsLabel
@onready var palette = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/Palette
@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/AnswerArea
@onready var submit_button = $CanvasLayer/Panel/SubmitButton
@onready var run_button = $CanvasLayer/Panel/RunButton
@onready var message_label = $CanvasLayer/Panel/MessageLabel
@onready var maze_board_holder = $CanvasLayer/Panel/VBoxContainer/MazeBoardHolder
@onready var exit_button = $CanvasLayer/Panel/ExitButton

func _ready():
	# Let PuzzleUI process even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS	
	instructions_label.text = instructions_text

	# DO NOT auto-add the Start block into the AnswerArea.
	# Instead, add all blocks from available_blocks (which should include the Start block).
	for block_data in available_blocks:
		var block_type = block_data.get("block_type", "move_up")
		var scene_path = _get_scene_for_block_type(block_type)
		if not ResourceLoader.exists(scene_path):
			push_warning("Scene path doesn't exist: %s" % scene_path)
			continue
		var block_scene = load(scene_path)
		var block_inst = block_scene.instantiate()
		if block_inst.get("block_type") != null:
			block_inst.block_type = block_type
		palette.add_child(block_inst)

	submit_button.pressed.connect(_on_SubmitButton_pressed)
	run_button.pressed.connect(_on_RunButton_pressed)
	exit_button.pressed.connect(_on_ExitButton_pressed)

	var MazeBoardScene = load("res://Scenes/MazeBoard.tscn")
	var maze_board_instance = MazeBoardScene.instantiate()
	maze_board_instance.maze_index = maze_index
	maze_board_holder.add_child(maze_board_instance)

	# For debugging: print a message when ready.
	print("PuzzleUI ready. Instructions: ", instructions_text)

# Helper to return scene path from block type.
func _get_scene_for_block_type(block_type: String) -> String:
	match block_type:
		"start":
			return "res://Scenes/StartItem.tscn"
		"for_loop":
			return "res://Scenes/ForLoopItem.tscn"
		"while_loop":
			return "res://Scenes/WhileLoopItem.tscn"
		"move_up", "move_down", "move_left", "move_right":
			return "res://Scenes/Item.tscn"
		_:
			return "res://Scenes/Item.tscn"

func _on_ExitButton_pressed():
	queue_free()
	get_tree().paused = false

# Build command tree from AnswerArea children.
func _build_command_tree() -> Array:
	var commands = []
	for item in answer_area.get_children():
		if not item.has_meta("block_type"):
			continue
		
		var block_type = item.get_meta("block_type", "")
		if block_type == "start":
			continue  # Skip the start node; it's just a marker.

		match block_type:
			"move_up", "move_down", "move_left", "move_right":
				commands.append(block_type)
			"for_loop":
				var loop_count = 2
				if item.has_method("get_loop_count"):
					loop_count = item.call("get_loop_count")
				var child_blocks = []
				if item.has_method("get_block_container"):
					var container = item.call("get_block_container")
					for sub_item in container.get_children():
						if sub_item.has_meta("block_type"):
							child_blocks.append(sub_item.get_meta("block_type"))
				commands.append({
					"type": "for_loop",
					"count": loop_count,
					"body": child_blocks
				})
			"while_loop":
				var child_blocks = []
				if item.has_method("get_block_container"):
					var container = item.call("get_block_container")
					for sub_item in container.get_children():
						if sub_item.has_meta("block_type"):
							child_blocks.append(sub_item.get_meta("block_type"))
				commands.append({
					"type": "while_loop",
					"body": child_blocks
				})
			_:
				commands.append(block_type)
	
	return commands

func _flatten_commands(nested_commands: Array) -> Array:
	var result = []
	for cmd in nested_commands:
		if cmd is String:
			result.append(cmd)
		elif cmd is Dictionary:
			if cmd.type == "for_loop":
				var repeated_body = []
				for i in range(cmd.count):
					repeated_body += _flatten_commands(cmd.body)
				result += repeated_body
			elif cmd.type == "while_loop":
				var artificial_limit = 10
				for i in range(artificial_limit):
					result += _flatten_commands(cmd.body)
			else:
				pass
	return result

func _on_SubmitButton_pressed():
	var start_block = null
	# Look for the start block in AnswerArea by meta:
	for child in answer_area.get_children():
		if child.get_meta("block_type", "") == "start":
			start_block = child
			break

	if start_block == null:
		message_label.text = "No Start block found!"
		return

	# Build command tree.
	var commands_list = _build_command_tree()
	print("🔍 Debug: About to execute commands:", commands_list)
	var linear_cmds = _flatten_commands(commands_list)
	print("🔍 Debug: Flattened command list:", linear_cmds)

	# Now simply check if the player is at the goal.
	var maze_board = maze_board_holder.get_child(0)
	if not maze_board:
		message_label.text = "Maze not set up properly."
		return
	
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var goal = maze_board.get_node_or_null("Goal") as Sprite2D
	var tile_size = Vector2(32, 32)
	var player_tile = Vector2i(player.position / tile_size)
	var goal_tile = Vector2i(goal.position / tile_size)
	
	if player_tile == goal_tile:
		message_label.text = "Correct solution!"
		await get_tree().create_timer(2).timeout
		queue_free()
	else:
		message_label.text = "Incorrect solution, try again!"
		await get_tree().create_timer(1).timeout
		_clear_answer_area_except_start()

func _clear_answer_area_except_start():
	for c in answer_area.get_children():
		if c.get_meta("block_type", "") != "start":
			c.queue_free()

func _on_RunButton_pressed():
	var start_block = null
	for child in answer_area.get_children():
		if child.get_meta("block_type", "") == "start":
			start_block = child
			break

	if not start_block:
		message_label.text = "No start block found!"
		return

	var commands_tree = _build_command_tree()
	print("🔍 Debug: About to execute commands:", commands_tree)
	var maze_board = maze_board_holder.get_child(0)
	if not maze_board:
		message_label.text = "No MazeBoard loaded!"
		return

	# Run the commands with animation.
	await _execute_nested_commands_on_maze(commands_tree, maze_board)


# --- Animated Movement and Execution Functions ---

func _execute_nested_commands_on_maze(commands_array: Array, maze_board: Node2D) -> void:
	print("\n🔍 DEBUG: Checking required MazeBoard nodes...")

	# Get required nodes (using TileMapLayer for floor and walls).
	var tilemap_layer = maze_board.get_node_or_null("TileMapLayer1") as TileMapLayer
	var walls_layer = maze_board.get_node_or_null("TileMapLayer2") as TileMapLayer
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var goal = maze_board.get_node_or_null("Goal") as Sprite2D  # Goal is a Sprite2D
	var animation_player = player.get_node_or_null("AnimationPlayer")  # AnimationPlayer under Player

	# Debug prints:
	if tilemap_layer == null:
		print("❌ ERROR: TileMapLayer1 is MISSING!")
	else:
		print("✅ TileMapLayer1 found.")
	if walls_layer == null:
		print("❌ ERROR: TileMapLayer2 is MISSING!")
	else:
		print("✅ TileMapLayer2 found.")
	if player == null:
		print("❌ ERROR: Player is MISSING!")
	else:
		print("✅ Player found.")
	if goal == null:
		print("❌ ERROR: Goal is MISSING!")
	else:
		print("✅ Goal found.")
	if animation_player == null:
		print("❌ ERROR: AnimationPlayer is MISSING!")
	else:
		print("✅ AnimationPlayer found.")

	if tilemap_layer == null or walls_layer == null or player == null or goal == null or animation_player == null:
		message_label.text = "Maze not set up properly. Check terminal for details."
		return

	var tile_size = Vector2(32, 32)
	var player_tile = Vector2i(player.position / tile_size)
	print("✅ Player starting tile:", player_tile)

	# Process each command sequentially.
	for command in commands_array:
		if command is String:
			print("▶️ Executing:", command)
			player_tile = await _move_player(command, player_tile, walls_layer, player, animation_player, tile_size)
		elif command is Dictionary:
			match command.type:
				"for_loop":
					print("🔄 Executing For Loop x", command.count)
					var count = command.count
					for i in range(count):
						player_tile = await _execute_sub_commands(command.body, walls_layer, player_tile, player, animation_player, tile_size)
				"while_loop":
					print("🔁 Executing While Loop")
					var safeguard = 30  # Prevent infinite loops
					while safeguard > 0:
						if _would_hit_wall(player_tile, command.body, walls_layer):
							print("⛔ While Loop stopped: wall detected.")
							break
						player_tile = await _execute_sub_commands(command.body, walls_layer, player_tile, player, animation_player, tile_size)
						safeguard -= 1
				_:
					print("⚠️ Unknown dictionary command:", command)
		
		# Check goal after each command.
		var goal_tile = Vector2i(goal.position / tile_size)
		if player_tile == goal_tile:
			print("🏆 Player reached the goal!")
			message_label.text = "You reached the goal!"
			break

	print("🎯 Final player tile:", player_tile)
	player.position = (player_tile as Vector2) * tile_size + (tile_size / 2)


func _execute_sub_commands(sub_cmds: Array, walls_layer: TileMapLayer, player_tile: Vector2i, player: CharacterBody2D, animation_player: AnimationPlayer, tile_size: Vector2) -> Vector2i:
	for c in sub_cmds:
		if c is String:
			player_tile = await _move_player(c, player_tile, walls_layer, player, animation_player, tile_size)
		else:
			print("⚠️ Unexpected nested command:", c)
	return player_tile

# Asynchronous _move_player plays the animation and moves smoothly.
func _move_player(cmd: String, player_tile: Vector2i, walls_layer: TileMapLayer, player: CharacterBody2D, animation_player: AnimationPlayer, tile_size: Vector2) -> Vector2i:
	print("... Attempting to move player with command:", cmd)
	var next_tile = player_tile
	match cmd:
		"move_up":    next_tile.y -= 1
		"move_down":  next_tile.y += 1
		"move_left":  next_tile.x -= 1
		"move_right": next_tile.x += 1
		_:
			return player_tile  # Unrecognized command.
	
	# Check for wall collision.
	if _is_wall(walls_layer, next_tile):
		message_label.text = "Player hit a wall!"
		print("🚧 Player hit a wall at tile:", next_tile)
		await _reset_player(player, tile_size)
		return player_tile  # Do not update tile.
	
	# Animate movement.
	await _animate_player_movement(player, animation_player, cmd, player.position, (next_tile as Vector2) * tile_size + (tile_size / 2))
	return next_tile

# Animate the player's movement and play the appropriate animation.
func _animate_player_movement(player: CharacterBody2D, animation_player: AnimationPlayer, cmd: String, _start_pos: Vector2, end_pos: Vector2) -> void:
	# Play the correct animation.
	match cmd:
		"move_up": animation_player.play("move_up")
		"move_down": animation_player.play("move_down")
		"move_left": animation_player.play("move_left")
		"move_right": animation_player.play("move_right")
	
	# Use a tween for smooth movement.
	var tween = player.create_tween()
	tween.tween_property(player, "position", end_pos, 0.3)
	await tween.finished
	animation_player.stop()

# Reset the player back to the starting tile (assumed at (2,2)).
func _reset_player(player: CharacterBody2D, tile_size: Vector2) -> void:
	message_label.text = "Resetting to start..."
	var start_tile = Vector2i(2, 2)  # Adjust if necessary.
	var start_pos = (start_tile as Vector2) * tile_size + (tile_size / 2)
	var tween = player.create_tween()
	tween.tween_property(player, "position", start_pos, 0.5)
	await tween.finished
	print("🔄 Player reset to start position:", start_pos)

func _simulate_move(cmd: String, player_tile: Vector2i, walls_layer: TileMapLayer) -> Vector2i:
	var next_tile = player_tile
	match cmd:
		"move_up":    next_tile.y -= 1
		"move_down":  next_tile.y += 1
		"move_left":  next_tile.x -= 1
		"move_right": next_tile.x += 1
		_:
			return player_tile  # Unrecognized command
	# If moving to next_tile hits a wall, return the current tile.
	if _is_wall(walls_layer, next_tile):
		return player_tile
	return next_tile


func _would_hit_wall(start_tile: Vector2i, commands: Array, walls_layer: TileMapLayer) -> bool:
	var temp_tile = start_tile
	for cmd in commands:
		if cmd is String:
			var new_tile = _simulate_move(cmd, temp_tile, walls_layer)
			# If the move does not change the tile, assume a wall blocked the move.
			if new_tile == temp_tile:
				return true
			temp_tile = new_tile
		else:
			print("⚠️ Unexpected command type in _would_hit_wall:", cmd)
	return false


func _is_wall(map: TileMapLayer, pos: Vector2i) -> bool:
	# Check if the given tile contains a wall.
	return map.get_cell_atlas_coords(pos) != Vector2i(-1, -1)
