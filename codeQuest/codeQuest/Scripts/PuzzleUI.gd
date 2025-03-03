extends Control

@export var available_blocks: Array = []
@export var instructions_text: String = ""
@export var expected_solution: Array = []
@export var maze_index: int = 0

# Player must start at (1,1), but the goal is now fixed at (11,11)
const START_TILE: Vector2i = Vector2i(1, 1)
const GOAL_TILE: Vector2i = Vector2i(11, 11)

@onready var instructions_label = $CanvasLayer/Panel/InstructionsLabel
@onready var palette = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/Palette
@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/AnswerArea
@onready var submit_button = $CanvasLayer/Panel/SubmitButton
@onready var run_button = $CanvasLayer/Panel/RunButton
@onready var message_label = $CanvasLayer/Panel/MessageLabel
@onready var maze_board_holder = $CanvasLayer/Panel/VBoxContainer/MazeBoardHolder
@onready var exit_button = $CanvasLayer/Panel/ExitButton

func _ready():
	# Allow processing even when paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	instructions_label.text = instructions_text

	# Load available blocks into the palette.
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

	# Connect UI signals.
	submit_button.pressed.connect(_on_SubmitButton_pressed)
	run_button.pressed.connect(_on_RunButton_pressed)
	exit_button.pressed.connect(_on_ExitButton_pressed)

	# Instantiate MazeBoard scene.
	var MazeBoardScene = load("res://Scenes/MazeBoard.tscn")
	var maze_board_instance = MazeBoardScene.instantiate()
	maze_board_instance.maze_index = maze_index
	maze_board_holder.add_child(maze_board_instance)

	print("PuzzleUI ready. Instructions:", instructions_text)


# ----------------------------------------------------------------
# RETURN SCENE PATH FOR BLOCK TYPE
# ----------------------------------------------------------------
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


# ----------------------------------------------------------------
# EXIT BUTTON
# ----------------------------------------------------------------
func _on_ExitButton_pressed():
	queue_free()
	get_tree().paused = false


# ----------------------------------------------------------------
# RECursively finds the node that has `get_loop_count()`
# ----------------------------------------------------------------
func _find_for_loop_instance(root: Node) -> Node:
	if root.has_method("get_loop_count"):
		print("   -> Found ForLoopItem node that has get_loop_count():", root)
		return root
	for child in root.get_children():
		var result = _find_for_loop_instance(child)
		if result != null:
			return result
	return null


# ----------------------------------------------------------------
# BUILD COMMAND TREE
# ----------------------------------------------------------------
func _build_command_tree() -> Array:
	var commands = []
	print("\n🔍 _build_command_tree() → Inspecting children of AnswerArea...")
	for item in answer_area.get_children():
		if not item.has_meta("block_type"):
			continue
		var block_type = item.get_meta("block_type", "")
		print("   Found block_type:", block_type)
		if block_type == "start":
			print("   (Skipping 'start') - not a command.")
			continue
		match block_type:
			"move_up", "move_down", "move_left", "move_right":
				print("   => Movement command appended:", block_type)
				commands.append(block_type)
			"for_loop":
				print("🔍 Found for_loop block. Inspecting children:", item.get_children())
				var loop_count = 2
				var for_loop_instance = _find_for_loop_instance(item)
				if for_loop_instance:
					loop_count = for_loop_instance.get_loop_count()
					print("✅ Successfully fetched loop count:", loop_count)
				else:
					print("❌ ERROR: get_loop_count() not found in item or its children:", item)
				var child_blocks = []
				if item.has_method("get_block_container"):
					var container = item.call("get_block_container")
					print("      -> Inspecting for_loop child blocks in 'BlockContainer'...")
					for sub_item in container.get_children():
						if sub_item.has_meta("block_type"):
							var sub_type = sub_item.get_meta("block_type")
							child_blocks.append(sub_type)
							print("         + Found child block_type in for_loop:", sub_type)
				commands.append({
					"type": "for_loop",
					"count": loop_count,
					"body": child_blocks
				})
				print("    => for_loop appended with body:", child_blocks)
			"while_loop":
				var child_list_while = []
				if item.has_method("get_block_container"):
					var c = item.call("get_block_container")
					print("      Inspecting while_loop body in BlockContainer...")
					for s in c.get_children():
						if s.has_meta("block_type"):
							var st = s.get_meta("block_type", "")
							child_list_while.append(st)
							print("         + Found child block in while_loop:", st)
				commands.append({
					"type": "while_loop",
					"body": child_list_while
				})
				print("   => while_loop appended with body:", child_list_while)
			_:
				print("   => Unrecognized block_type:", block_type, "appending anyway.")
				commands.append(block_type)
	print("🔍 Final command_tree is:", commands)
	return commands


# ----------------------------------------------------------------
# FLATTEN COMMAND TREE
# ----------------------------------------------------------------
func _flatten_commands(nested_commands: Array) -> Array:
	print("\n🔍 _flatten_commands() → Starting with:", nested_commands)
	var result = []
	for cmd in nested_commands:
		if cmd is String:
			result.append(cmd)
		elif cmd is Dictionary:
			if cmd.type == "for_loop":
				print("   🔄 Flattening for_loop x", cmd.count)
				for i in range(cmd.count):
					result += _flatten_commands(cmd.body)
			elif cmd.type == "while_loop":
				print("   🔁 Flattening while_loop up to artificial limit=10")
				var artificial_limit = 10
				for i in range(artificial_limit):
					result += _flatten_commands(cmd.body)
			else:
				print("   ⚠️ Unknown dict command in flatten:", cmd)
		else:
			print("   ⚠️ Unknown command type in flatten:", cmd)
	print("🔍 _flatten_commands() so far =>", result)
	return result


# ----------------------------------------------------------------
# SUBMIT BUTTON
# ----------------------------------------------------------------
func _on_SubmitButton_pressed():
	var start_block = null
	for child in answer_area.get_children():
		if child.get_meta("block_type", "") == "start":
			start_block = child
			break
	if not start_block:
		message_label.text = "No Start block found!"
		return

	var commands_list = _build_command_tree()
	print("\n🔍 Debug: About to Submit these commands:", commands_list)
	var flattened = _flatten_commands(commands_list)
	print("🔍 Flattened commands (Submit):", flattened)

	# Instead of checking the MazeBoard goal node, we check if the player is at GOAL_TILE (11,11)
	var maze_board = maze_board_holder.get_child(0)
	if not maze_board:
		message_label.text = "Maze not set up properly."
		return

	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var tile_size = Vector2(32, 32)
	var player_tile = Vector2i(player.position / tile_size)
	
	if player_tile == GOAL_TILE:
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


# ----------------------------------------------------------------
# RUN BUTTON
# ----------------------------------------------------------------
func _on_RunButton_pressed():
	var maze_board = maze_board_holder.get_child(0)
	if not maze_board:
		message_label.text = "No MazeBoard loaded!"
		return

	# Removed the check for START_TILE to allow commands to run from any position.
	var commands_tree = _build_command_tree()
	print("\n🔍 Debug: About to RUN these commands:", commands_tree)
	await _execute_nested_commands_on_maze(commands_tree, maze_board)

	# After execution, check if the player reached the goal (11,11)
	var tile_size = Vector2(32, 32)
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var player_tile = Vector2i(player.position / tile_size)
	if player_tile != GOAL_TILE:
		message_label.text = "You did not reach the goal. Resetting..."
		await get_tree().create_timer(1).timeout
		await _reset_player(player, tile_size)
	else:
		message_label.text = "You reached the goal!"


# ----------------------------------------------------------------
# EXECUTE NESTED COMMANDS
# ----------------------------------------------------------------
func _execute_nested_commands_on_maze(commands_array: Array, maze_board: Node2D) -> void:
	print("\n🔍 _execute_nested_commands_on_maze:", commands_array)
	var tilemap_layer = maze_board.get_node_or_null("TileMapLayer1") as TileMapLayer
	var walls_layer = maze_board.get_node_or_null("TileMapLayer2") as TileMapLayer
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	var goal = maze_board.get_node_or_null("Goal") as Sprite2D
	var animation_player = player.get_node_or_null("AnimationPlayer")

	if tilemap_layer == null or walls_layer == null or player == null or goal == null or animation_player == null:
		message_label.text = "Maze not set up properly."
		return

	var tile_size = Vector2(32,32)
	var player_tile = Vector2i(player.position / tile_size)
	print("✅ Player starting tile:", player_tile)

	for command in commands_array:
		if command is String:
			print("▶️ Single command:", command)
			player_tile = await _move_player(command, player_tile, maze_board, player, animation_player, tile_size)
		elif command is Dictionary:
			match command.type:
				"for_loop":
					print("🔄 For Loop (x", command.count, ") with body:", command.body)
					var count = command.count
					for i in range(count):
						player_tile = await _execute_sub_commands(command.body, maze_board, player_tile, player, animation_player, tile_size)
				"while_loop":
					print("🔁 While Loop: run body until next move would hit a wall.")
					var safeguard = 30
					while safeguard > 0:
						if _would_hit_wall(player_tile, command.body, maze_board):
							print("⛔ Next step would hit a wall, stopping while_loop.")
							break
						player_tile = await _execute_sub_commands(command.body, maze_board, player_tile, player, animation_player, tile_size)
						safeguard -= 1
				_:
					print("⚠️ Unknown dictionary command:", command)
		else:
			print("⚠️ Unknown command type in nested commands:", command)

	var goal_tile = Vector2i(GOAL_TILE)
	if player_tile == goal_tile:
		print("🏆 Player reached the goal mid-run!")
		message_label.text = "You reached the goal!"
	print("🎯 Final player tile after run:", player_tile)
	player.position = Vector2(player_tile.x, player_tile.y) * tile_size + (tile_size / 2)


# ----------------------------------------------------------------
# EXECUTE SUB COMMANDS
# ----------------------------------------------------------------
func _execute_sub_commands(sub_cmds: Array, maze_board: Node2D, player_tile: Vector2i,
						   player: CharacterBody2D, animation_player: AnimationPlayer, tile_size: Vector2) -> Vector2i:
	print("   -> _execute_sub_commands with sub_cmds:", sub_cmds)
	var new_tile = player_tile
	for c in sub_cmds:
		if c is String:
			new_tile = await _move_player(c, new_tile, maze_board, player, animation_player, tile_size)
		else:
			print("   ⚠️ Unexpected nested command in sub_cmds:", c)
	return new_tile


# ----------------------------------------------------------------
# MOVE PLAYER
# ----------------------------------------------------------------
func _move_player(cmd: String, player_tile: Vector2i, maze_board: Node2D,
				  player: CharacterBody2D, animation_player: AnimationPlayer, tile_size: Vector2) -> Vector2i:
	print("      ... Attempting move:", cmd, "from tile:", player_tile)
	var next_tile = player_tile
	match cmd:
		"move_up":    next_tile.y -= 1
		"move_down":  next_tile.y += 1
		"move_left":  next_tile.x -= 1
		"move_right": next_tile.x += 1
		_:
			print("      ⚠️ Unrecognized move command:", cmd)
			return player_tile

	# Check for wall using MazeBoard's is_wall method.
	var maze_board_ref = maze_board as MazeBoard
	if maze_board_ref.is_wall(next_tile):
		print("      🚧 Hit a wall at tile:", next_tile, "! Reset player.")
		message_label.text = "Player hit a wall!"
		await _reset_player(player, tile_size)
		return Vector2i(1,1)

	await _animate_player_movement(player, animation_player, cmd, player.position,
		Vector2(next_tile.x, next_tile.y) * tile_size + (tile_size / 2))
	print("      ✅ Movement done. Player tile now:", next_tile)
	return next_tile


# ----------------------------------------------------------------
# ANIMATE PLAYER MOVEMENT
# ----------------------------------------------------------------
func _animate_player_movement(player: CharacterBody2D, animation_player: AnimationPlayer,
							  cmd: String, start_pos: Vector2, end_pos: Vector2) -> void:
	print("         🎞️ Animating:", cmd, "from", start_pos, "to", end_pos)
	match cmd:
		"move_up":    animation_player.play("move_up")
		"move_down":  animation_player.play("move_down")
		"move_left":  animation_player.play("move_left")
		"move_right": animation_player.play("move_right")
	var tween = player.create_tween()
	tween.tween_property(player, "position", end_pos, 0.3)
	await tween.finished
	animation_player.stop()


# ----------------------------------------------------------------
# RESET PLAYER
# ----------------------------------------------------------------
func _reset_player(player: CharacterBody2D, tile_size: Vector2) -> void:
	var start_pos = Vector2(START_TILE.x, START_TILE.y) * tile_size + (tile_size / 2)
	print("         🔄 Reset player to start:", start_pos)
	message_label.text = "Resetting to start..."
	var tween = player.create_tween()
	tween.tween_property(player, "position", start_pos, 0.5)
	await tween.finished
	print("         ✅ Reset done. Player at:", player.position)


# ----------------------------------------------------------------
# SIMULATE MOVE (for while_loop checks)
# ----------------------------------------------------------------
func _simulate_move(cmd: String, player_tile: Vector2i) -> Vector2i:
	var next_tile = player_tile
	match cmd:
		"move_up":    next_tile.y -= 1
		"move_down":  next_tile.y += 1
		"move_left":  next_tile.x -= 1
		"move_right": next_tile.x += 1
		_:
			return player_tile
	return next_tile


# ----------------------------------------------------------------
# WOULD HIT WALL? (While loop check)
# ----------------------------------------------------------------
func _would_hit_wall(start_tile: Vector2i, commands: Array, maze_board: Node2D) -> bool:
	var temp_tile = start_tile
	print("   -> _would_hit_wall() from tile:", temp_tile, "with commands:", commands)
	var maze_board_ref = maze_board as MazeBoard
	for cmd in commands:
		if cmd is String:
			var new_tile = _simulate_move(cmd, temp_tile)
			if maze_board_ref.is_wall(new_tile):
				print("      🚧 Next step blocked by wall at tile:", new_tile)
				return true
			temp_tile = new_tile
		else:
			print("      ⚠️ Unexpected subcommand in while_loop:", cmd)
	return false
