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
		0: _load_maze_10()
		1: _load_maze_1()
		2: _load_maze_2()
		3: _load_maze_3()
		4: _load_maze_4()
		5: _load_maze_5()
		6: _load_maze_6()
		7: _load_maze_7()
		8: _load_maze_8()
		9: _load_maze_9()
		10: _load_maze_10()
		11: _load_maze_11()
		12: _load_maze_12()
		_:
			_load_maze_0()

func _load_maze_0() -> void:
	# Original simple maze
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x == 0 or x == 24 or y == 0 or y == 24:
				walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5,0))
	# A couple extra walls
	walls.set_cell(Vector2i(2,2), 0, Vector2i(7,3))
	walls.set_cell(Vector2i(22,22), 0, Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2, 2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22, 22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_1() -> void:
	# Puzzle 1: Medium Maze with vertical and horizontal chunks
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x == 0 or x == 24 or y == 0 or y == 24:
				walls.set_cell(Vector2i(x,y), 0, Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y), 0, Vector2i(5,0))
	for yy in range(3, 10):
		walls.set_cell(Vector2i(5, yy), 0, Vector2i(7,3))
	for xx in range(8, 15):
		walls.set_cell(Vector2i(xx, 12), 0, Vector2i(7,3))
	for yy in range(14, 20):
		walls.set_cell(Vector2i(17, yy), 0, Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_2() -> void:
	# Puzzle 2: Spiral Maze (simpler version)
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y), 0, Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y), 0, Vector2i(5,0))
	var i = 3
	var max_val = 21
	while i < max_val:
		for x in range(i, max_val):
			walls.set_cell(Vector2i(x, i), 0, Vector2i(7,3))
		for y in range(i, max_val):
			walls.set_cell(Vector2i(max_val, y), 0, Vector2i(7,3))
		for x in range(max_val, i, -1):
			walls.set_cell(Vector2i(x, max_val), 0, Vector2i(7,3))
		for y in range(max_val, i, -1):
			walls.set_cell(Vector2i(i, y), 0, Vector2i(7,3))
		i += 2
		max_val -= 2
	walls.set_cell(Vector2i(3,10), -1)
	walls.set_cell(Vector2i(21,15), -1)
	walls.set_cell(Vector2i(10,3), -1)
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_3() -> void:
	# Puzzle 3: Vertical corridors with gaps
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	# Create vertical walls every 4 columns with a gap every 3 rows
	for x in range(4, 21, 4):
		for y in range(2, 23):
			if y % 3 != 0:
				walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_4() -> void:
	# Puzzle 4: Alternating horizontal walls with gaps
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for y in range(4, 21, 4):
		for x in range(2, 23):
			if x % 4 != 0:
				walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_5() -> void:
	# Puzzle 5: Grid challenge – small wall blocks forming a grid
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for x in range(4, 21, 4):
		for y in range(4, 21, 4):
			for dx in range(3):
				for dy in range(3):
					walls.set_cell(Vector2i(x+dx, y+dy),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_6() -> void:
	# Puzzle 6: A more intricate spiral labyrinth
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	var i = 3
	var max_val = 21
	while i < max_val:
		for x in range(i, max_val):
			walls.set_cell(Vector2i(x, i),0,Vector2i(7,3))
		for y in range(i, max_val):
			walls.set_cell(Vector2i(max_val, y),0,Vector2i(7,3))
		for x in range(max_val, i, -1):
			walls.set_cell(Vector2i(x, max_val),0,Vector2i(7,3))
		for y in range(max_val, i, -1):
			walls.set_cell(Vector2i(i, y),0,Vector2i(7,3))
		i += 2
		max_val -= 2
	# Open a couple gaps
	walls.set_cell(Vector2i(4,3), -1)
	walls.set_cell(Vector2i(20,10), -1)
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_7() -> void:
	# Puzzle 7: Random obstacles scattered throughout the board
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for i in range(30):
		var rx = randi() % 23 + 1
		var ry = randi() % 23 + 1
		walls.set_cell(Vector2i(rx,ry),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_8() -> void:
	# Puzzle 8: Labyrinth corridors – alternating horizontal walls with a twist
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for y in range(3, 22, 4):
		for x in range(2, 23):
			if x % 3 != 0:
				walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_9() -> void:
	# Puzzle 9: Zigzag vertical corridors
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for x in range(4, 22, 4):
		for y in range(2, 23):
			if (x / 4) % 2 == 0:
				if y % 2 == 0:
					walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
			else:
				if y % 2 != 0:
					walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_10() -> void:
	# Puzzle 10: Multiple short corridors creating a twisty layout
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for y in range(3, 22, 3):
		for x in range(2, 23):
			if (x + y) % 3 != 0:
				walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_11() -> void:
	# Puzzle 11: Dense obstacles in the center forming a maze
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for x in range(8, 18):
		for y in range(8, 18):
			if (x + y) % 2 == 0:
				walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2

func _load_maze_12() -> void:
	# Puzzle 12: Ultimate labyrinth – complex with several choke points
	tilemap.clear()
	walls.clear()
	for x in range(25):
		for y in range(25):
			if x==0 or x==24 or y==0 or y==24:
				walls.set_cell(Vector2i(x,y),0,Vector2i(7,3))
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(5,0))
	for y in range(3, 22, 2):
		for x in range(3, 22, 2):
			if (x + y) % 3 == 0:
				walls.set_cell(Vector2i(x, y),0,Vector2i(7,3))
	# Force a few open corridors
	for x in range(10, 16):
		walls.set_cell(Vector2i(x, 12), -1)
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2,2)) + Vector2(tilemap.tile_set.tile_size)/2
	goal.position = tilemap.map_to_local(Vector2i(22,22)) + Vector2(tilemap.tile_set.tile_size)/2
