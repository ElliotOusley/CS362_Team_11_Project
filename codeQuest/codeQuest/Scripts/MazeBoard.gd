extends Node2D
class_name MazeBoard

@export var maze_index: int = 0

@onready var tilemap: TileMapLayer = get_node_or_null("TileMapLayer1")
@onready var walls: TileMapLayer = get_node_or_null("TileMapLayer2")
@onready var player: CharacterBody2D = get_node_or_null("Player")
@onready var goal: Sprite2D = get_node_or_null("Goal")  # If your Goal is a Sprite2D
@onready var animation_player: AnimationPlayer = player.get_node_or_null("AnimationPlayer")

var wall_positions: Dictionary = {}

func get_cell_center(cell: Vector2i) -> Vector2:
	var doubled_cell = cell * 2
	return tilemap.map_to_local(doubled_cell) + Vector2(tilemap.tile_set.tile_size) / 2

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
	
	print("\n📜 WALL DICTIONARY (Before Start):")
	for key in wall_positions.keys():
		print("   🧱 Wall at:", key)

func _set_wall(cell: Vector2i, layer_id: int, atlas_coord: Vector2i):
	var doubled_cell = cell * 2
	walls.set_cell(doubled_cell, layer_id, atlas_coord)
	if atlas_coord.x == -1:
		if wall_positions.has(doubled_cell):
			wall_positions.erase(doubled_cell)
	else:
		wall_positions[doubled_cell] = true

func _remove_wall(cell: Vector2i):
	var doubled_cell = cell * 2
	walls.set_cell(doubled_cell, 0, Vector2i(-1, -1))
	if wall_positions.has(doubled_cell):
		wall_positions.erase(doubled_cell)

func is_wall(pos: Vector2i) -> bool:
	var doubled_pos = pos * 2
	print("\n🔍 Checking is_wall()")
	print("   🟡 Received Position:", pos)
	print("   🔵 Doubled Position:", doubled_pos)
	var wall_exists = wall_positions.has(doubled_pos)
	print("   ❓ Wall Found:", wall_exists)
	return wall_exists

func _load_maze(index: int) -> void:
	match index:
		0: _load_maze_2()
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
	# Original simple maze (example from your snippet)
	tilemap.clear()
	walls.clear()
	wall_positions.clear()
	for x in range(25):
		for y in range(25):
			if x == 0 or x == 24 or y == 0 or y == 24:
				walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, y)] = true
			else:
				tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5,0))
	# A couple of extra walls
	walls.set_cell(Vector2i(2, 2), 0, Vector2i(7,3))
	wall_positions[Vector2i(2, 2)] = true
	walls.set_cell(Vector2i(22, 22), 0, Vector2i(7,3))
	wall_positions[Vector2i(22, 22)] = true
	
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2, 2)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(22, 22)) + Vector2(tilemap.tile_set.tile_size) / 2

#
# Helper: Clears and places a default floor everywhere
#         and then a 2-tile-thick border (outer wall).
#
func _setup_base_layout():
	tilemap.clear()
	walls.clear()
	wall_positions.clear()
	
	# Fill floor
	for x in range(25):
		for y in range(25):
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(5,0))
	
	# Outer wall
	for x in range(25):
		for y in range(25):
			if x == 0 or x == 24 or y == 0 or y == 24:  # One-tile-thick border
				walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, y)] = true


# Helper: Teleport the Player and Goal to (2,2) and (22,22) respectively
func _place_player_and_goal():
	await get_tree().process_frame
	player.position = tilemap.map_to_local(Vector2i(2, 2)) + Vector2(tilemap.tile_set.tile_size) / 2
	goal.position = tilemap.map_to_local(Vector2i(22, 22)) + Vector2(tilemap.tile_set.tile_size) / 2

##########################################################
# Maze 1: Very simple interior - single double-thick wall
##########################################################
func _load_maze_1() -> void:
	_setup_base_layout()

	# We'll place a simple "stripe" in the middle, 2 tiles thick
	# that requires the player to go around it.
	for x in range(10, 15):
		for y_offset in range(2): # 2-thick
			var y = 12 + y_offset
			walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))
			wall_positions[Vector2i(x, y)] = true
	
	_place_player_and_goal()

##########################################################
# Maze 2: Vertical corridors made of 2-thick pillars
##########################################################
func _load_maze_2() -> void:
	_setup_base_layout()
	
	# Create a few 2-thick vertical walls, leaving breaks so there's a path.
	for block_x in [4, 8, 12, 16, 20]:
		for y in range(4, 21):
			# Skip a gap at y=10..11 so there is a pass-through
			if y in [10, 11]:
				continue
			walls.set_cell(Vector2i(block_x, y), 0, Vector2i(7,3))
			wall_positions[Vector2i(block_x, y)] = true
			walls.set_cell(Vector2i(block_x+1, y), 0, Vector2i(7,3))
			wall_positions[Vector2i(block_x+1, y)] = true
	
	_place_player_and_goal()

##########################################################
# Maze 3: Horizontal "ladder" walls, 2-thick
##########################################################
func _load_maze_3() -> void:
	_setup_base_layout()
	
	# We'll make horizontal bars that partially block the path.
	for block_y in [4, 8, 12, 16, 20]:
		for x in range(3, 22):
			# Leave a gap around x=10..11 to pass
			if x in [10, 11]:
				continue
			walls.set_cell(Vector2i(x, block_y), 0, Vector2i(7,3))
			wall_positions[Vector2i(x, block_y)] = true
			walls.set_cell(Vector2i(x, block_y+1), 0, Vector2i(7,3))
			wall_positions[Vector2i(x, block_y+1)] = true
	
	_place_player_and_goal()

##########################################################
# Maze 4: "Grid" of thick walls, leaving some open "rooms"
##########################################################
func _load_maze_4() -> void:
	_setup_base_layout()
	
	# Vertical lines at x=5, x=10, x=15, x=20 (2 thick => x=5..6, etc.)
	var verticals = [5, 10, 15, 20]
	for vx in verticals:
		for x_offset in range(2):
			for y in range(2, 23):
				if y == 2 or y == 22:
					# Let the border remain closed (already set), skip
					continue
				walls.set_cell(Vector2i(vx + x_offset, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(vx + x_offset, y)] = true
	
	# Horizontal lines at y=5, y=10, y=15, y=20 (2 thick => y=5..6, etc.)
	var horizontals = [5, 10, 15, 20]
	for hy in horizontals:
		for y_offset in range(2):
			for x in range(2, 23):
				if x == 2 or x == 22:
					continue
				walls.set_cell(Vector2i(x, hy + y_offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, hy + y_offset)] = true
	
	# Carve a few passages so there's a path from (2,2) to (22,22).
	# We'll remove some walls in the grid to ensure solvability.
	_remove_wall(Vector2i(5, 3))
	_remove_wall(Vector2i(5, 4))
	_remove_wall(Vector2i(10, 6))
	_remove_wall(Vector2i(10, 7))
	_remove_wall(Vector2i(15, 12))
	_remove_wall(Vector2i(15, 13))
	_remove_wall(Vector2i(20, 17))
	_remove_wall(Vector2i(20, 18))

	_place_player_and_goal()

##########################################################
# Maze 5: Spiral-like path using 2-thick walls
##########################################################
func _load_maze_5() -> void:
	_setup_base_layout()
	
	# We build a thick spiral starting near the border
	var min_x = 2
	var max_x = 22
	var min_y = 2
	var max_y = 22
	
	while min_x < max_x and min_y < max_y:
		# Top edge (horizontal)
		for x in range(min_x, max_x+1):
			for offset in range(2):
				walls.set_cell(Vector2i(x, min_y+offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, min_y+offset)] = true
		min_y += 2

		# Right edge (vertical)
		for y in range(min_y, max_y+1):
			for offset in range(2):
				walls.set_cell(Vector2i(max_x-offset, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(max_x-offset, y)] = true
		max_x -= 2

		# Bottom edge (horizontal)
		if min_y <= max_y:
			for x in range(max_x, min_x-1, -1):
				for offset in range(2):
					walls.set_cell(Vector2i(x, max_y-offset), 0, Vector2i(7,3))
					wall_positions[Vector2i(x, max_y-offset)] = true
			max_y -= 2

		# Left edge (vertical)
		if min_x <= max_x:
			for y in range(max_y, min_y-1, -1):
				for offset in range(2):
					walls.set_cell(Vector2i(min_x+offset, y), 0, Vector2i(7,3))
					wall_positions[Vector2i(min_x+offset, y)] = true
			min_x += 2
	
	# Carve out a path from (2,2) to (22,22)
	# We'll remove some spiral walls to ensure there's an actual route.
	_remove_wall(Vector2i(2, 2))      # start open
	_remove_wall(Vector2i(2, 3))
	_remove_wall(Vector2i(3, 3))
	_remove_wall(Vector2i(4, 4))
	_remove_wall(Vector2i(5, 5))
	_remove_wall(Vector2i(6, 6))
	_remove_wall(Vector2i(7, 7))
	_remove_wall(Vector2i(8, 8))
	_remove_wall(Vector2i(9, 8))
	_remove_wall(Vector2i(10, 8))
	_remove_wall(Vector2i(11, 8))
	_remove_wall(Vector2i(12, 9))
	_remove_wall(Vector2i(13, 10))
	_remove_wall(Vector2i(14, 11))
	_remove_wall(Vector2i(15, 12))
	_remove_wall(Vector2i(16, 13))
	_remove_wall(Vector2i(17, 14))
	_remove_wall(Vector2i(18, 15))
	_remove_wall(Vector2i(19, 16))
	_remove_wall(Vector2i(20, 17))
	_remove_wall(Vector2i(21, 18))
	_remove_wall(Vector2i(22, 22))    # end open

	_place_player_and_goal()

##########################################################
# Maze 6: Zig-zag pathways
##########################################################
func _load_maze_6() -> void:
	_setup_base_layout()
	
	# We create a series of 2-thick zig-zags that force a winding path.
	for zig in range(3, 22, 4):  # each zig row start
		# Horizontal top of zig
		for x in range(2, 15):
			for offset in range(2):
				walls.set_cell(Vector2i(x, zig+offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, zig+offset)] = true
		# Vertical down
		for y_offset in range(4):
			for offset in range(2):
				walls.set_cell(Vector2i(14+offset, zig+y_offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(14+offset, zig+y_offset)] = true
		# Horizontal bottom of zig
		for x in range(14, 23):
			for offset in range(2):
				walls.set_cell(Vector2i(x, zig+3+offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, zig+3+offset)] = true

	# Carve a straightforward route near the top/left so the path is solvable
	for y in range(2, 23):
		_remove_wall(Vector2i(2, y))
		_remove_wall(Vector2i(3, y))

	_place_player_and_goal()

##########################################################
# Maze 7: Checkerboard-like blocks (2x2) but with openings
##########################################################
func _load_maze_7() -> void:
	_setup_base_layout()

	# Place 2x2 blocks scattered, leaving some checkerboard pattern
	for x_block in range(2, 23, 4):
		for y_block in range(2, 23, 4):
			# Create a 2x2 block of walls
			for x_off in range(2):
				for y_off in range(2):
					walls.set_cell(Vector2i(x_block + x_off, y_block + y_off), 0, Vector2i(7,3))
					wall_positions[Vector2i(x_block + x_off, y_block + y_off)] = true

	# Carve a path in the first column/row so there's guaranteed progression
	for y in range(2, 23):
		_remove_wall(Vector2i(2, y))
		_remove_wall(Vector2i(3, y))

	_place_player_and_goal()

##########################################################
# Maze 8: Multiple concentric "rings" of 2-thick walls
##########################################################
func _load_maze_8() -> void:
	_setup_base_layout()
	
	# We'll create smaller and smaller squares inside, 2-thick
	var ring_min = 4
	var ring_max = 20
	while ring_min < ring_max:
		# Top ring row
		for x in range(ring_min, ring_max+1):
			for offset in range(2):
				walls.set_cell(Vector2i(x, ring_min+offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, ring_min+offset)] = true
		# Bottom ring row
		for x in range(ring_max, ring_min-1, -1):
			for offset in range(2):
				walls.set_cell(Vector2i(x, ring_max-offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, ring_max-offset)] = true
		# Left ring col
		for y in range(ring_min, ring_max+1):
			for offset in range(2):
				walls.set_cell(Vector2i(ring_min+offset, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(ring_min+offset, y)] = true
		# Right ring col
		for y in range(ring_max, ring_min-1, -1):
			for offset in range(2):
				walls.set_cell(Vector2i(ring_max-offset, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(ring_max-offset, y)] = true
		
		ring_min += 3
		ring_max -= 3

	# Carve out a diagonal path from top-left to bottom-right
	for step in range(0, 21):
		_remove_wall(Vector2i(2+step, 2+step))

	_place_player_and_goal()

##########################################################
# Maze 9: Weaving horizontal and vertical bars
##########################################################
func _load_maze_9() -> void:
	_setup_base_layout()

	# Place thick horizontal bars on even rows, vertical bars on odd columns
	for y_bar in range(4, 21, 4):
		for x in range(3, 22):
			for offset in range(2):
				walls.set_cell(Vector2i(x, y_bar+offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, y_bar+offset)] = true

	for x_bar in range(4, 21, 4):
		for y in range(3, 22):
			for offset in range(2):
				walls.set_cell(Vector2i(x_bar+offset, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(x_bar+offset, y)] = true

	# Carve out a snake-like route:
	_remove_wall(Vector2i(2, 2))
	for col in range(2, 23):
		_remove_wall(Vector2i(col, 3))
	for row in range(3, 23):
		_remove_wall(Vector2i(22, row))

	_place_player_and_goal()

##########################################################
# Maze 10: Dense "window-pane" pattern, with strategic holes
##########################################################
func _load_maze_10() -> void:
	_setup_base_layout()
	
	# We'll make a big cross every 3 tiles, 2 thick,
	# but systematically remove some segments to keep it solvable.
	for x in range(2, 23):
		if x % 3 == 0 or x % 3 == 1:
			for y in range(2, 23):
				walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, y)] = true
	for y in range(2, 23):
		if y % 3 == 0 or y % 3 == 1:
			for x in range(2, 23):
				walls.set_cell(Vector2i(x, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, y)] = true

	# Carve some holes to ensure there's at least one long path:
	for y_hole in range(2, 23):
		if y_hole % 4 == 2:
			_remove_wall(Vector2i(2, y_hole))
			_remove_wall(Vector2i(3, y_hole))
	for x_hole in range(2, 23):
		if x_hole % 4 == 2:
			_remove_wall(Vector2i(x_hole, 22))
			_remove_wall(Vector2i(x_hole, 21))

	_place_player_and_goal()

##########################################################
# Maze 11: Random-ish "chunky" blocks with a forced path
##########################################################
func _load_maze_11() -> void:
	_setup_base_layout()
	
	# We'll just place some random thick blocks, ensuring a path remains.
	# (Example pattern – you can randomize or get more complex.)
	var blocks = [
		Vector2i(5, 5), Vector2i(5, 6),
		Vector2i(8, 10), Vector2i(8, 11), 
		Vector2i(9, 10), Vector2i(9, 11),
		Vector2i(14, 14), Vector2i(14, 15),
		Vector2i(15, 14), Vector2i(15, 15),
		Vector2i(10, 6), Vector2i(10, 7)
	]
	for bpos in blocks:
		walls.set_cell(bpos, 0, Vector2i(7,3))
		wall_positions[bpos] = true

	# Thicken those blocks horizontally/vertically
	for bpos in blocks:
		var bx = bpos.x
		var by = bpos.y
		var neighbors = [
			Vector2i(bx+1, by),
			Vector2i(bx,   by+1),
			Vector2i(bx+1, by+1)
		]
		for nb in neighbors:
			walls.set_cell(nb, 0, Vector2i(7,3))
			wall_positions[nb] = true

	# Carve out a corridor along the top row and left column
	for x in range(2, 23):
		_remove_wall(Vector2i(x, 2))
		_remove_wall(Vector2i(x, 3))
	for y in range(2, 23):
		_remove_wall(Vector2i(2, y))
		_remove_wall(Vector2i(3, y))

	_place_player_and_goal()

##########################################################
# Maze 12: Heavier partitioning with a twisting route
##########################################################
func _load_maze_12() -> void:
	_setup_base_layout()
	
	# Partition the inside into thick partitions in a "maze-y" pattern:
	# We'll do vertical partitions spaced out and horizontal partitions offset.
	for part_x in [5, 10, 15, 20]:
		for y in range(2, 23):
			for offset in range(2):
				walls.set_cell(Vector2i(part_x+offset, y), 0, Vector2i(7,3))
				wall_positions[Vector2i(part_x+offset, y)] = true
	
	for part_y in [5, 10, 15, 20]:
		for x in range(2, 23):
			for offset in range(2):
				walls.set_cell(Vector2i(x, part_y+offset), 0, Vector2i(7,3))
				wall_positions[Vector2i(x, part_y+offset)] = true

	# Carve "doors" in each partition to create a winding path
	var door_positions = [
		Vector2i(5,3), Vector2i(6,3),
		Vector2i(10,7), Vector2i(11,7),
		Vector2i(15,9), Vector2i(16,9),
		Vector2i(20,13), Vector2i(21,13),
		Vector2i(9,10), Vector2i(9,11),
		Vector2i(14,15), Vector2i(14,16)
	]
	for dp in door_positions:
		_remove_wall(dp)
	
	_place_player_and_goal()
