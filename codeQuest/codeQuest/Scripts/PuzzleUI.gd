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

func _on_SubmitButton_pressed():
	var start_block = null
	for child in answer_area.get_children():
		if child.get_meta("block_type","") == "start":
			start_block = child
			break

	if start_block == null:
		message_label.text = "No Start block found!"
		return

	var commands_list = _build_command_list(start_block)
	var linear_cmds = _flatten_commands(commands_list)

	if linear_cmds == expected_solution:
		message_label.text = "Correct solution!"
		await get_tree().create_timer(2).timeout
		queue_free()
	else:
		message_label.text = "Incorrect solution, try again!"
		await get_tree().create_timer(1).timeout
		_clear_answer_area_except_start()

func _clear_answer_area_except_start():
	for c in answer_area.get_children():
		if c.get_meta("block_type","") != "start":
			c.queue_free()

func _build_command_list(block_node: TextureRect) -> Array:
	var result = []
	var block_type = block_node.get_meta("block_type","")
	match block_type:
		"start":
			var next_block = _find_block_to_the_right(block_node)
			if next_block:
				result += _build_command_list(next_block)
		"move_up", "move_down", "move_left", "move_right":
			result.append(block_type)
			var nb2 = _find_block_to_the_right(block_node)
			if nb2:
				result += _build_command_list(nb2)
		"for_loop":
			var loop_count = 2
			var for_script = block_node.get_script()
			if for_script and for_script.has_method("get_loop_count"):
				loop_count = block_node.call("get_loop_count")
			var child_container = block_node.call("get_block_container")
			var child_cmds = []
			for item in child_container.get_children():
				if item is TextureRect:
					child_cmds += _build_command_list(item)
			result.append({
				"type": "for_loop",
				"count": loop_count,
				"body": child_cmds
			})
			var next_block_f = _find_block_to_the_right(block_node)
			if next_block_f:
				result += _build_command_list(next_block_f)
		"while_loop":
			var child_container_w = block_node.call("get_block_container")
			var child_cmds_w = []
			for item in child_container_w.get_children():
				if item is TextureRect:
					child_cmds_w += _build_command_list(item)
			result.append({
				"type": "while_loop",
				"body": child_cmds_w
			})
			var next_block_w = _find_block_to_the_right(block_node)
			if next_block_w:
				result += _build_command_list(next_block_w)
		_:
			pass
	return result

func _find_block_to_the_right(current_block: TextureRect) -> TextureRect:
	var best_dist = 999999.0
	var best_block: TextureRect = null
	for child in answer_area.get_children():
		if child == current_block:
			continue
		if child is TextureRect:
			var dx = child.position.x - current_block.position.x
			var dy = abs(child.position.y - current_block.position.y)
			if dx > 20 and dy < 80:
				var dist = current_block.position.distance_to(child.position)
				if dist < best_dist:
					best_dist = dist
					best_block = child
	return best_block

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
					# For puzzle checking, naive flatten
					result += _flatten_commands(cmd.body)
			else:
				pass
	return result

func _on_RunButton_pressed():
	var start_block = null
	for child in answer_area.get_children():
		if child.get_meta("block_type", "") == "start":
			start_block = child
			break

	if not start_block:
		message_label.text = "No start block found!"
		return

	var commands_tree = _build_command_list(start_block)
	var maze_board = maze_board_holder.get_child(0)
	if not maze_board:
		message_label.text = "No MazeBoard loaded!"
		return

	_execute_nested_commands_on_maze(commands_tree, maze_board)

func _execute_nested_commands_on_maze(commands_tree: Array, maze_board: Node):
	var tilemap_layer = maze_board.get_node_or_null("TileMapLayer1") as TileMap
	var walls_layer = maze_board.get_node_or_null("TileMapLayer2") as TileMap
	var player = maze_board.get_node_or_null("Player") as CharacterBody2D

	if not (tilemap_layer and walls_layer and player):
		push_error("MazeBoard not set up properly!")
		return

	var tile_size = Vector2(32, 32)
	var player_tile = Vector2i(player.position / tile_size)

	for command in commands_tree:
		_run_command(command, walls_layer, tilemap_layer, player_tile)

	player.position = Vector2(player_tile) * tile_size + tile_size / 2
	message_label.text = "Commands executed!"

func _run_command(cmd, walls_layer: TileMap, tilemap_layer: TileMap, player_tile: Vector2i):
	if cmd is String:
		_move_player(cmd, player_tile, walls_layer)
	elif cmd is Dictionary:
		if cmd.type == "for_loop":
			for i in range(cmd.count):
				for subcmd in cmd.body:
					_run_command(subcmd, walls_layer, tilemap_layer, player_tile)
		elif cmd.type == "while_loop":
			var safeguard = 40
			while safeguard > 0:
				var can_run_all = true
				for subcmd in cmd.body:
					if subcmd is String:
						var test_tile = player_tile
						match subcmd:
							"move_up": test_tile.y -= 1
							"move_down": test_tile.y += 1
							"move_left": test_tile.x -= 1
							"move_right": test_tile.x += 1
						if _is_wall(walls_layer, test_tile):
							can_run_all = false
							break
				if not can_run_all:
					break
				for subcmd in cmd.body:
					_run_command(subcmd, walls_layer, tilemap_layer, player_tile)
				safeguard -= 1

func _move_player(cmd: String, player_tile: Vector2i, walls_layer: TileMap):
	var next_tile = player_tile
	match cmd:
		"move_up":    next_tile.y -= 1
		"move_down":  next_tile.y += 1
		"move_left":  next_tile.x -= 1
		"move_right": next_tile.x += 1
		_:
			return

	if _is_wall(walls_layer, next_tile):
		return
	else:
		player_tile.x = next_tile.x
		player_tile.y = next_tile.y

func _is_wall(map: TileMap, pos: Vector2i) -> bool:
	# Checking on layer 0
	return map.get_cell_source_id(0, pos) != -1








#extends Control
#
#@export var available_blocks: Array = [
	#{ "block_type": "move_up", "display_text": "Move Up" },
	#{ "block_type": "move_down", "display_text": "Move Down" },
	#{ "block_type": "move_left", "display_text": "Move Left" },
	#{ "block_type": "move_right", "display_text": "Move Right" }
#]
#@export var instructions_text: String = "Use the blocks to guide the Player to the Goal!"
#@export var expected_solution: Array = []
#@export var maze_index: int = 0
#
#@onready var instructions_label = $CanvasLayer/Panel/VBoxContainer/InstructionsLabel
#@onready var palette = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/Palette
#@onready var answer_area = $CanvasLayer/Panel/VBoxContainer/DragAndDropHolder/AnswerArea
#@onready var submit_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SubmitButton
#@onready var run_button = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/RunButton
#@onready var message_label = $CanvasLayer/Panel/VBoxContainer/MessageLabel
#@onready var maze_board_holder = $CanvasLayer/Panel/VBoxContainer/MazeBoardHolder
#@onready var exit_button = $CanvasLayer/Panel/ExitButton
#
#func _ready():
	#process_mode = Node.PROCESS_MODE_ALWAYS
	#print("🟢 PuzzleUI Ready")
	#instructions_label.text = instructions_text
#
	## Add the "Start" block to the AnswerArea so the user sees a starting block.
	#var start_block = preload("res://Scenes/Item.tscn").instantiate()
	#start_block.block_type = "start"
	#answer_area.add_child(start_block)
#
	## Create the palette blocks
	#for block_data in available_blocks:
		#var item_instance = preload("res://Scenes/Item.tscn").instantiate()
		#item_instance.block_type = block_data["block_type"]
		#palette.add_child(item_instance)
#
	#submit_button.pressed.connect(_on_SubmitButton_pressed)
	#run_button.pressed.connect(_on_RunButton_pressed)
#
	#exit_button.pressed.connect(_on_ExitButton_pressed)
	#
	## Instantiate the MazeBoard
	#var maze_board_instance = preload("res://Scenes/MazeBoard.tscn").instantiate()
	## Make sure to set the maze index so it loads the correct puzzle!
	#maze_board_instance.maze_index = maze_index
#
	#call_deferred("_add_maze_board", maze_board_instance)
#
#func _add_maze_board(maze_board_instance):
	#maze_board_holder.add_child(maze_board_instance)
	#print("✅ MazeBoard successfully added with index =", maze_index)
#
#func _on_ExitButton_pressed():
	#print("🚪 Exiting PuzzleUI...")
	#queue_free()  
	#get_tree().paused = false  
#
#
#func _on_SubmitButton_pressed():
	#var solution = []
	## Gather block_types from each child in answer_area
	#for item in answer_area.get_children():
		## The "start" block has block_type = "start", but skip it if you don't want it in solution
		## If you want to consider "start" as part of the solution, keep it in.
		#if item.has_meta("block_type"):
			#var block_t = item.get_meta("block_type")
			#if block_t != "start":  # skip "start" block or keep it, up to you
				#solution.append(block_t)
#
	#if solution == expected_solution:
		#message_label.text = "Correct! Puzzle solved."
		#await get_tree().create_timer(2).timeout
		#_close_puzzle()
	#else:
		#message_label.text = "Incorrect! Try again."
		#await get_tree().create_timer(1).timeout
		#_clear_answer_area()
#
#func _close_puzzle():
	#queue_free()
#
#func _clear_answer_area():
	#for item in answer_area.get_children():
		## Keep the "start" block so the user always sees it.
		#if item.has_meta("block_type") and item.get_meta("block_type") == "start":
			#continue
		#item.queue_free()
#
#func _on_RunButton_pressed():
	#var commands = []
	#for item in answer_area.get_children():
		#if item.has_meta("block_type"):
			#var b = item.get_meta("block_type")
			## skip "start" block
			#if b != "start":
				#commands.append(b)
		#else:
			#print("⚠️ WARNING: Dropped item does not contain a block_type!")
#
	#var maze_board = maze_board_holder.get_child(0)
	#if maze_board == null:
		#message_label.text = "No maze loaded."
		#return
#
	#_execute_commands_on_maze(commands, maze_board)
#
#func _execute_commands_on_maze(commands: Array, maze_board: Node2D) -> void:
	#print("🔍 Checking nodes in MazeBoard...")
#
	#var tilemap_layer = maze_board.get_node_or_null("TileMapLayer1") as TileMapLayer
	#var walls_layer = maze_board.get_node_or_null("TileMapLayer2") as TileMapLayer
	#var player = maze_board.get_node_or_null("Player") as CharacterBody2D
	#var goal = maze_board.get_node_or_null("Goal") as CharacterBody2D
#
	#print("📌 tilemap_layer: ", tilemap_layer)
	#print("📌 walls_layer: ", walls_layer)
	#print("📌 player: ", player)
	#print("📌 goal: ", goal)
#
	#if tilemap_layer == null or walls_layer == null or player == null or goal == null:
		#print("❌ ERROR: One or more required nodes are missing in MazeBoard!")
		#message_label.text = "Maze not set up properly."
		#return
#
	## ✅ Convert player's position to tile coordinates using TileMapLayer
	#var tile_size = Vector2(32, 32)  # Adjust based on your tileset size
	#var player_tile = Vector2i(player.position / tile_size)
#
	#var i = 0
	#while i < commands.size():
		#var cmd = commands[i]
		#match cmd:
			#"move_up", "move_down", "move_left", "move_right":
				#player_tile = _move_player(player_tile, cmd, tilemap_layer, walls_layer)
				#i += 1
			#"for_3_times", "for_2_times":
				#var repeats = 3 if cmd == "for_3_times" else 2
				#if i + 1 < commands.size():
					#var next_cmd = commands[i + 1]
					#for rep in range(repeats):
						#player_tile = _move_player(player_tile, next_cmd, tilemap_layer, walls_layer)
					#i += 2
				#else:
					#i += 1
			#"if_wall_ahead":
				#if i + 1 < commands.size():
					#var conditional_cmd = commands[i + 1]
					#if _is_wall_ahead(player_tile, conditional_cmd, walls_layer):
						#i += 2  # Skip the next command
					#else:
						#player_tile = _move_player(player_tile, conditional_cmd, tilemap_layer, walls_layer)
						#i += 2
				#else:
					#i += 1
			#_:
				#i += 1
#
	## ✅ Convert tile position back to world position
	#player.position = Vector2(player_tile) * tile_size + tile_size / 2
#
	## ✅ Check if the player reached the goal
	#var goal_tile = Vector2i(goal.position / tile_size)
	#if player_tile == goal_tile:
		#message_label.text = "You reached the goal!"
	#else:
		#message_label.text = "You ended on tile %s" % str(player_tile)
#
#
#func _move_player(current_tile: Vector2i, cmd: String, tilemap_layer: TileMapLayer, walls_layer: TileMapLayer) -> Vector2i:
	#var next_tile = current_tile
	#var player = maze_board_holder.get_child(0).get_node("Player")
	#var animation_player = player.get_node_or_null("AnimationPlayer")  # ✅ Get AnimationPlayer inside Player
#
	#match cmd:
		#"move_up":
			#next_tile.y -= 1
			#if animation_player:
				#animation_player.play("walk_up")  # Play walking up animation
		#"move_down":
			#next_tile.y += 1
			#if animation_player:
				#animation_player.play("walk_down")  # Play walking down animation
		#"move_left":
			#next_tile.x -= 1
			#if animation_player:
				#animation_player.play("walk_left")  # Play walking left animation
		#"move_right":
			#next_tile.x += 1
			#if animation_player:
				#animation_player.play("walk_right")  # Play walking right animation
		#_:
			#pass
#
	## If a wall is in the way, stop animation and return current position
	#if _is_wall(walls_layer, next_tile):
		#if animation_player:
			#animation_player.stop()
		#return current_tile
#
	#return next_tile  # Move to the new position if no wall is there
#
#
#
#func _is_wall(walls_layer: TileMapLayer, tile_coords: Vector2i) -> bool:
	## ✅ Correct usage: get_cell_atlas_coords() takes only the tile position
	#return walls_layer.get_cell_atlas_coords(tile_coords) != Vector2i(-1, -1)
#
#func _is_wall_ahead(current_tile: Vector2i, cmd: String, walls_layer: TileMapLayer) -> bool:
	#var check_tile = current_tile
#
	#match cmd:
		#"move_up":
			#check_tile.y -= 1
		#"move_down":
			#check_tile.y += 1
		#"move_left":
			#check_tile.x -= 1
		#"move_right":
			#check_tile.x += 1
		#_:
			#pass
#
	#return _is_wall(walls_layer, check_tile)
