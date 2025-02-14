# Scripts/MazeBoard.gd
extends Node2D
class_name MazeBoard

@export var maze_index: int = 0

@onready var tilemap: TileMap = $TileMap
@onready var player: CharacterBody2D = $Player
@onready var goal: Sprite2D = $Goal

func _ready():
	# Load the maze layout for maze_index
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
			_load_maze_0()

# ---------------------------------------------------------------------
# Maze 0: A simple 5x5 grid with one wall in the middle
# ---------------------------------------------------------------------
func _load_maze_0() -> void:
	tilemap.clear()

	# Ensure the TileSet is valid before using map_to_local()
	if tilemap.tile_set == null:
		print("❌ ERROR: TileMap does not have a valid TileSet assigned!")
		return

	for x in range(5):
		for y in range(5):
			tilemap.set_cell(0, Vector2i(x, y), 0)  # Set floor tiles

	tilemap.set_cell(0, Vector2i(2, 2), 1)  # Place a single wall in the center

	# Ensure that tilemap.map_to_local() is called after tiles exist
	await get_tree().process_frame  # Wait for one frame

	# Set player position safely
	player.position = tilemap.map_to_local(Vector2i(0, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(4, 4)) + Vector2(tilemap.tile_set.tile_size) / 2



# ---------------------------------------------------------------------
# Maze 1
# ---------------------------------------------------------------------
func _load_maze_1() -> void:
	tilemap.clear()
	for x in range(5):
		for y in range(5):
			tilemap.set_cell(0, Vector2i(x, y), 0)  # floor
	# Make a vertical wall line
	for y in range(5):
		tilemap.set_cell(0, Vector2i(2, y), 1)

	player.position = tilemap.map_to_world(Vector2i(0, 4)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(4, 0)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
# Maze 2
# ---------------------------------------------------------------------
func _load_maze_2() -> void:
	tilemap.clear()
	for x in range(6):
		for y in range(6):
			tilemap.set_cell(0, Vector2i(x, y), 0)  # floor
	# Walls around perimeter
	for x in range(6):
		tilemap.set_cell(0, Vector2i(x, 0), 1)
		tilemap.set_cell(0, Vector2i(x, 5), 1)
	for y in range(6):
		tilemap.set_cell(0, Vector2i(0, y), 1)
		tilemap.set_cell(0, Vector2i(5, y), 1)

	# An internal wall
	tilemap.set_cell(0, Vector2i(3, 3), 1)

	player.position = tilemap.map_to_world(Vector2i(1, 1)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(4, 4)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_3() -> void:
	tilemap.clear()
	# 6x6 again
	for x in range(6):
		for y in range(6):
			tilemap.set_cell(0, Vector2i(x, y), 0)

	# Some random walls
	tilemap.set_cell(0, Vector2i(2, 1), 1)
	tilemap.set_cell(0, Vector2i(3, 2), 1)
	tilemap.set_cell(0, Vector2i(2, 3), 1)
	tilemap.set_cell(0, Vector2i(1, 4), 1)

	player.position = tilemap.map_to_world(Vector2i(0, 2)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(5, 2)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_4() -> void:
	tilemap.clear()
	# 7x7
	for x in range(7):
		for y in range(7):
			tilemap.set_cell(0, Vector2i(x, y), 0)

	# Make a diagonal wall
	for i in range(5):
		tilemap.set_cell(0, Vector2i(i+1, i), 1)

	player.position = tilemap.map_to_world(Vector2i(0, 6)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(6, 0)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_5() -> void:
	tilemap.clear()
	# 7x7
	for x in range(7):
		for y in range(7):
			tilemap.set_cell(0, Vector2i(x, y), 0)

	# Spiral-like walls
	tilemap.set_cell(0, Vector2i(1,1), 1)
	tilemap.set_cell(0, Vector2i(1,2), 1)
	tilemap.set_cell(0, Vector2i(1,3), 1)
	tilemap.set_cell(0, Vector2i(2,3), 1)
	tilemap.set_cell(0, Vector2i(3,3), 1)
	tilemap.set_cell(0, Vector2i(3,2), 1)

	player.position = tilemap.map_to_world(Vector2i(0, 0)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(6, 6)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_6() -> void:
	tilemap.clear()
	# 8x8
	for x in range(8):
		for y in range(8):
			tilemap.set_cell(0, Vector2i(x, y), 0)
	# random walls
	tilemap.set_cell(0, Vector2i(2, 2), 1)
	tilemap.set_cell(0, Vector2i(2, 3), 1)
	tilemap.set_cell(0, Vector2i(5, 5), 1)
	tilemap.set_cell(0, Vector2i(6, 5), 1)

	player.position = tilemap.map_to_world(Vector2i(1, 7)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(7, 0)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_7() -> void:
	tilemap.clear()
	for x in range(8):
		for y in range(8):
			tilemap.set_cell(0, Vector2i(x, y), 0)

	# More intricate pattern
	# Just a random pattern
	tilemap.set_cell(0, Vector2i(1,1), 1)
	tilemap.set_cell(0, Vector2i(2,1), 1)
	tilemap.set_cell(0, Vector2i(3,2), 1)
	tilemap.set_cell(0, Vector2i(4,4), 1)
	tilemap.set_cell(0, Vector2i(4,3), 1)
	tilemap.set_cell(0, Vector2i(1,6), 1)

	player.position = tilemap.map_to_world(Vector2i(0, 0)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(7, 7)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_8() -> void:
	tilemap.clear()
	for x in range(8):
		for y in range(8):
			tilemap.set_cell(0, Vector2i(x, y), 0)

	# Another pattern with a corridor
	for x in range(8):
		tilemap.set_cell(0, Vector2i(x, 3), 1)
	# leave a gap
	tilemap.set_cell(0, Vector2i(4, 3), 0)

	player.position = tilemap.map_to_world(Vector2i(0, 4)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(7, 2)) + tilemap.tile_set.tile_size / 2

# ---------------------------------------------------------------------
func _load_maze_9() -> void:
	tilemap.clear()
	for x in range(9):
		for y in range(9):
			tilemap.set_cell(0, Vector2i(x, y), 0)

	# Harder pattern
	# Let's put a perimeter
	for i in range(9):
		tilemap.set_cell(0, Vector2i(i, 0), 1)
		tilemap.set_cell(0, Vector2i(i, 8), 1)
		tilemap.set_cell(0, Vector2i(0, i), 1)
		tilemap.set_cell(0, Vector2i(8, i), 1)

	# Some internal walls
	tilemap.set_cell(0, Vector2i(4, 4), 1)
	tilemap.set_cell(0, Vector2i(3, 4), 1)
	tilemap.set_cell(0, Vector2i(5, 4), 1)
	tilemap.set_cell(0, Vector2i(4, 3), 1)
	tilemap.set_cell(0, Vector2i(4, 5), 1)

	player.position = tilemap.map_to_world(Vector2i(1, 1)) + tilemap.tile_set.tile_size / 2
	goal.position = tilemap.map_to_world(Vector2i(7, 7)) + tilemap.tile_set.tile_size / 2
