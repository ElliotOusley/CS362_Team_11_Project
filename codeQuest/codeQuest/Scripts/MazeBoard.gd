# Scripts/MazeBoard.gd
extends Node2D
class_name MazeBoard

@export var maze_index: int = 0

@onready var tilemap: TileMapLayer = get_node_or_null("TileMapLayer1")  # ✅ Ensure this exists
@onready var walls: TileMapLayer = get_node_or_null("TileMapLayer2")  # ✅ Ensure this exists
@onready var player: CharacterBody2D = get_node_or_null("Player")  # ✅ Ensure this exists
@onready var goal: Sprite2D = get_node_or_null("Goal")  # ✅ Goal exists, but let's be sure

func _ready():
	# Debugging
	print("🔍 Checking MazeBoard child nodes:")
	for child in get_children():
		print("  - ", child.name)

	if get_node_or_null("TileMapLayer1") == null:
		print("❌ ERROR: TileMapLayer1 is missing at runtime!")
		
	if tilemap == null:
		print("❌ ERROR: TileMapLayer1 (tilemap) is missing from MazeBoard!")
		return
	if walls == null:
		print("❌ ERROR: TileMapLayer2 (walls) is missing from MazeBoard!")
		return
	if player == null:
		print("❌ ERROR: Player node is missing from MazeBoard!")
		return
	if goal == null:
		print("❌ ERROR: Goal node is missing from MazeBoard!")  # Shouldn't happen
		return

	print("✅ MazeBoard setup is correct. Loading maze...")
	
	print("🔍 Debugging Sprite Colors in MazeBoard")

	if has_node("TileMapLayer1"):
		var tilemap = get_node("TileMapLayer1")
		print("🟢 TileMapLayer1 Modulate:", tilemap.modulate)

	if has_node("TileMapLayer2"):
		var walls = get_node("TileMapLayer2")
		print("🟢 TileMapLayer2 Modulate:", walls.modulate)

	if has_node("Player"):
		var player = get_node("Player")
		print("🟢 Player Modulate:", player.modulate)

	if has_node("Goal"):
		var goal = get_node("Goal")
		print("🟢 Goal Modulate:", goal.modulate)
	_load_maze(maze_index)

func _load_maze(index: int) -> void:
	match index:
		0:
			_load_maze_0()
		1:
			_load_maze_1()
		2:
			_load_maze_2()
		3:
			_load_maze_3()
		4:
			_load_maze_4()
		5:
			_load_maze_5()
		6:
			_load_maze_6()
		7:
			_load_maze_7()
		8:
			_load_maze_8()
		9:
			_load_maze_9()
		_:
			print("Maze index out of range, defaulting to Maze 0")
			_load_maze_1()

# ---------------------------------------------------------------------
# Maze 0: A simple 5x5 grid with one wall in the middle
# ---------------------------------------------------------------------
func _load_maze_0() -> void:
	tilemap.clear()
	walls.clear()

	# Ensure TileMapLayers exist before modifying them
	if tilemap == null or walls == null:
		print("❌ ERROR: TileMapLayers are missing, cannot set up the maze.")
		return

	for x in range(5):
		for y in range(5):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5, 0))  # Floor tiles

	walls.set_cell(Vector2i(2, 2), 1, Vector2i(7, 3))  # A wall at (2,2)

	# Ensure everything is loaded before setting the player position
	await get_tree().process_frame  

	if player:
		player.position = tilemap.map_to_local(Vector2i(0, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
		print("✅ Player positioned at:", player.position)
	else:
		print("❌ ERROR: Player not found in MazeBoard!")


# ---------------------------------------------------------------------
# Maze 1
# ---------------------------------------------------------------------
func _load_maze_1() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(5):
		for y in range(5):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5, 0))  # Floor
	for y in range(5):
		walls.set_cell(Vector2i(2, y), 1, Vector2i(7, 3))  # Vertical wall at x=2
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(0, 4)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(4, 0)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 2
# ---------------------------------------------------------------------
func _load_maze_2() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(6):
		for y in range(6):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))  # Floor
	for x in range(6):
		walls.set_cell(Vector2i(x, 0), 1, Vector2i(0, 0))
		walls.set_cell(Vector2i(x, 5), 1, Vector2i(0, 0))
	for y in range(6):
		walls.set_cell(Vector2i(0, y), 1, Vector2i(0, 0))
		walls.set_cell(Vector2i(5, y), 1, Vector2i(0, 0))
	walls.set_cell(Vector2i(3, 3), 1, Vector2i(0, 0))  # Internal wall
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(1, 1)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(4, 4)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 3
# ---------------------------------------------------------------------
func _load_maze_3() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(6):
		for y in range(6):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	walls.set_cell(Vector2i(2, 1), 1, Vector2i(0, 0))
	walls.set_cell(Vector2i(3, 2), 1, Vector2i(0, 0))
	walls.set_cell(Vector2i(2, 3), 1, Vector2i(0, 0))
	walls.set_cell(Vector2i(1, 4), 1, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(0, 2)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(5, 2)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 4
# ---------------------------------------------------------------------
func _load_maze_4() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(7):
		for y in range(7):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	for i in range(5):
		walls.set_cell(Vector2i(i + 1, i), 1, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(0, 6)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(6, 0)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 5
# ---------------------------------------------------------------------
func _load_maze_5() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(7):
		for y in range(7):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(1, 1), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(1, 2), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(1, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(2, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(3, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(3, 2), 1, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(0, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(6, 6)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 6
# ---------------------------------------------------------------------
func _load_maze_6() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(8):
		for y in range(8):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(2, 2), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(2, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(5, 5), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(6, 5), 1, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(1, 7)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(7, 0)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 7
# ---------------------------------------------------------------------
func _load_maze_7() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(8):
		for y in range(8):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(1, 1), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(2, 1), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(3, 2), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(4, 4), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(4, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(1, 6), 1, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(0, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(7, 7)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 8
# ---------------------------------------------------------------------
func _load_maze_8() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(8):
		for y in range(8):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	for x in range(8):
		tilemap.set_cell(Vector2i(x, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(4, 3), 0, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(0, 4)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(7, 2)) + Vector2(tilemap.tile_set.tile_size) / 2

# ---------------------------------------------------------------------
# Maze 9
# ---------------------------------------------------------------------
func _load_maze_9() -> void:
	tilemap.clear()
	walls.clear()
	for x in range(9):
		for y in range(9):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	for i in range(9):
		tilemap.set_cell(Vector2i(i, 0), 1, Vector2i(0, 0))
		tilemap.set_cell(Vector2i(i, 8), 1, Vector2i(0, 0))
		tilemap.set_cell(Vector2i(0, i), 1, Vector2i(0, 0))
		tilemap.set_cell(Vector2i(8, i), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(4, 4), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(3, 4), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(5, 4), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(4, 3), 1, Vector2i(0, 0))
	tilemap.set_cell(Vector2i(4, 5), 1, Vector2i(0, 0))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(1, 1)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(7, 7)) + Vector2(tilemap.tile_set.tile_size) / 2
