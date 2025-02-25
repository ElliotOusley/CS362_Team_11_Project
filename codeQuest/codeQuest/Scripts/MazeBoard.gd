extends Node2D
class_name MazeBoard

@export var maze_index: int = 0

@onready var tilemap: TileMapLayer = get_node_or_null("TileMapLayer1")
@onready var walls: TileMapLayer = get_node_or_null("TileMapLayer2")
@onready var player: CharacterBody2D = get_node_or_null("Player")
@onready var goal: Sprite2D = get_node_or_null("Goal")  # If your Goal is a Sprite2D
@onready var animation_player: AnimationPlayer = player.get_node_or_null("AnimationPlayer")

func _ready():
	print("🔍 Checking MazeBoard child nodes:")
	for child in get_children():
		print("  - ", child.name)

	if tilemap == null:
		print("❌ ERROR: TileMapLayer1 is missing!")
		return
	if walls == null:
		print("❌ ERROR: TileMapLayer2 is missing!")
		return
	if player == null:
		print("❌ ERROR: Player node is missing!")
		return
	if goal == null:
		print("❌ ERROR: Goal node is missing!")
		return
	if animation_player == null:
		print("❌ ERROR: AnimationPlayer not found in Player!")

	print("✅ MazeBoard setup is correct. Loading maze index:", maze_index)
	_load_maze(maze_index)

func _load_maze(index: int) -> void:
	match index:
		0:
			_load_maze_0()
		_:
			_load_maze_0()


func _load_maze_0() -> void:
	tilemap.clear()
	walls.clear()

	for x in range(25):
		for y in range(25):
			if (x == 0 || x == 24 || y == 0 || y == 24):
				walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))  # Outer walls
			else:
				tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5,0)) # Floor

	walls.set_cell(Vector2i(2,2), 0, Vector2i(7,3))  # Some extra wall
	walls.set_cell(Vector2i(22,22), 0, Vector2i(7,3))

	await get_tree().process_frame

	# Position player
	if player:
		player.position = tilemap.map_to_local(Vector2i(2, 2)) + Vector2(tilemap.tile_set.tile_size)/2

	# Position goal
	if goal:
		goal.position = tilemap.map_to_local(Vector2i(22, 22)) + Vector2(tilemap.tile_set.tile_size)/2
#
#
## ---------------------------------------------------------------------
## Maze 1
## ---------------------------------------------------------------------
#func _load_maze_1() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(5):
		#for y in range(5):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5, 0))  # Floor
	#for y in range(5):
		#walls.set_cell(Vector2i(2, y), 1, Vector2i(7, 3))  # Vertical wall at x=2
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(0, 4)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(4, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 2
## ---------------------------------------------------------------------
#func _load_maze_2() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(6):
		#for y in range(6):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))  # Floor
	#for x in range(6):
		#walls.set_cell(Vector2i(x, 0), 1, Vector2i(0, 0))
		#walls.set_cell(Vector2i(x, 5), 1, Vector2i(0, 0))
	#for y in range(6):
		#walls.set_cell(Vector2i(0, y), 1, Vector2i(0, 0))
		#walls.set_cell(Vector2i(5, y), 1, Vector2i(0, 0))
	#walls.set_cell(Vector2i(3, 3), 1, Vector2i(0, 0))  # Internal wall
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(1, 1)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(4, 4)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 3
## ---------------------------------------------------------------------
#func _load_maze_3() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(6):
		#for y in range(6):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#walls.set_cell(Vector2i(2, 1), 1, Vector2i(0, 0))
	#walls.set_cell(Vector2i(3, 2), 1, Vector2i(0, 0))
	#walls.set_cell(Vector2i(2, 3), 1, Vector2i(0, 0))
	#walls.set_cell(Vector2i(1, 4), 1, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(0, 2)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(5, 2)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 4
## ---------------------------------------------------------------------
#func _load_maze_4() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(7):
		#for y in range(7):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#for i in range(5):
		#walls.set_cell(Vector2i(i + 1, i), 1, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(0, 6)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(6, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 5
## ---------------------------------------------------------------------
#func _load_maze_5() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(7):
		#for y in range(7):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(1, 1), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(1, 2), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(1, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(2, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(3, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(3, 2), 1, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(0, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(6, 6)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 6
## ---------------------------------------------------------------------
#func _load_maze_6() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(8):
		#for y in range(8):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(2, 2), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(2, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(5, 5), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(6, 5), 1, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(1, 7)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(7, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 7
## ---------------------------------------------------------------------
#func _load_maze_7() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(8):
		#for y in range(8):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(1, 1), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(2, 1), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(3, 2), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(4, 4), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(4, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(1, 6), 1, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(0, 0)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(7, 7)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 8
## ---------------------------------------------------------------------
#func _load_maze_8() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(8):
		#for y in range(8):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#for x in range(8):
		#tilemap.set_cell(Vector2i(x, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(4, 3), 0, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(0, 4)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(7, 2)) + Vector2(tilemap.tile_set.tile_size) / 2
#
## ---------------------------------------------------------------------
## Maze 9
## ---------------------------------------------------------------------
#func _load_maze_9() -> void:
	#tilemap.clear()
	#walls.clear()
	#for x in range(9):
		#for y in range(9):
			#tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	#for i in range(9):
		#tilemap.set_cell(Vector2i(i, 0), 1, Vector2i(0, 0))
		#tilemap.set_cell(Vector2i(i, 8), 1, Vector2i(0, 0))
		#tilemap.set_cell(Vector2i(0, i), 1, Vector2i(0, 0))
		#tilemap.set_cell(Vector2i(8, i), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(4, 4), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(3, 4), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(5, 4), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(4, 3), 1, Vector2i(0, 0))
	#tilemap.set_cell(Vector2i(4, 5), 1, Vector2i(0, 0))
	#await get_tree().process_frame
	#player.position = tilemap.map_to_local(Vector2i(1, 1)) + Vector2(tilemap.tile_set.tile_size) / 2
	#goal.position = tilemap.map_to_local(Vector2i(7, 7)) + Vector2(tilemap.tile_set.tile_size) / 2
