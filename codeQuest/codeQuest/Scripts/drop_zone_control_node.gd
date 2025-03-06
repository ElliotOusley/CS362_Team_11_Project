#extends Panel
#
## Preload the scenes for each block type.
#const FOR_LOOP_SCENE  = preload("res://Scenes/ForLoopItem.tscn")
#const WHILE_LOOP_SCENE = preload("res://Scenes/WhileLoopItem.tscn")
#const MOVEMENT_SCENE  = preload("res://Scenes/Item.tscn")
#
#@onready var ICONS: Dictionary = {
	#"move_up":    preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	#"move_down":  preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	#"move_left":  preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	#"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png"),
	#"start":      preload("res://Sprites/CodeBlockSprites/start.png"),
	#"for_loop":   preload("res://Sprites/CodeBlockSprites/forLoop.png"),
	#"while_loop": preload("res://Sprites/CodeBlockSprites/whileLoop.png")
#}
#
#func _ready():
	#print("✅ DropZoneControl READY. I'm a Panel for dropping items.")
#
## ------------------------------------------------------------
## Godot will call these if you connect drop signals manually,
## or if you rename them to can_drop_data() and drop_data().
## ------------------------------------------------------------
#func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	#return data is Dictionary and data.has("block_type") and data.has("texture")
#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#print("📥 DropZoneControl received:", data)
	#if not _can_drop_data(at_position, data):
		#print("❌ ERROR: Invalid data dropped!")
		#return
#
	#var block_type = data["block_type"]
	#var new_item: Control = null
#
	## Instantiate the proper scene for each block type.
	#match block_type:
		#"for_loop":
			#new_item = FOR_LOOP_SCENE.instantiate()
		#"while_loop":
			#new_item = WHILE_LOOP_SCENE.instantiate()
		#"move_up", "move_down", "move_left", "move_right":
			#new_item = MOVEMENT_SCENE.instantiate()
		#"start":
			## Create a Start block manually (VBoxContainer with icon).
			#new_item = VBoxContainer.new()
			#new_item.custom_minimum_size = Vector2(70, 70)
			#new_item.alignment = BoxContainer.ALIGNMENT_CENTER
			#new_item.set_meta("block_type", "start")
#
			#var icon = TextureRect.new()
			#icon.texture = ICONS["start"]
			#icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			#icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			#icon.custom_minimum_size = Vector2(70, 70)
			#new_item.add_child(icon)
		#_:
			#print("⚠️ WARNING: Unrecognized block type!", block_type)
			#return
#
	#if not new_item:
		#print("❌ ERROR: Failed to instantiate block!")
		#return
#
	## ------------------------------------------------------------------
	## 1) Set the "block_type" *property* if the scene script supports it
	##    (Many of your item scenes have an exported block_type property.)
	## 2) Also set meta() for quick lookups in _apply_snap_logic().
	## 3) THEN add_child(new_item) so that _ready() sees the correct block_type.
	## ------------------------------------------------------------------
	#if "block_type" in new_item:
		#new_item.block_type = block_type  # calls setter if it exists
	#new_item.set_meta("block_type", block_type)
	#
	#add_child(new_item)                 # Now the node enters the scene
	#new_item.position = at_position     # Place near drop location
#
	#print("✅ Successfully dropped item:", block_type, "at", at_position)
#
	## Enforce: If no block existed before, only a "start" block can remain.
	#if get_child_count() == 1 and block_type != "start":
		#print("❌ Must drop a Start block first.")
		#new_item.queue_free()
		#return
#
	#_apply_snap_logic(new_item, block_type, at_position)
#
#
#func _get_loop_body_contents(loop_body: VBoxContainer) -> String:
	#var body_contents = []
	#for child in loop_body.get_children():
		#if child.has_meta("block_type"):
			#print("📝 Found child in loop:", child, "Type:", child.get_meta("block_type"))
			#body_contents.append(child.get_meta("block_type"))
		#else:
			#print("⚠️ Skipped child without metadata:", child)
	#return ", ".join(body_contents)
#
#
## -------------------------------------------------------------------
## Improved Snap Logic (no recursive up-chain; just attach to nearest block)
## -------------------------------------------------------------------
#func _apply_snap_logic(new_block: Control, block_type: String, at_position: Vector2) -> void:
	#print("\n📍 Trying to place:", block_type, "at", at_position)
#
	## Ensure a Start block exists before placing other blocks
	#var has_start = false
	#for child in get_children():
		#if child.has_meta("block_type") and child.get_meta("block_type") == "start":
			#has_start = true
			#break
#
	#if not has_start and block_type != "start":
		#print("❌ Drop rejected: Must drop a Start block first.")
		#new_block.queue_free()
		#return
#
	## Default (free) position
	#var new_pos = at_position - new_block.custom_minimum_size * 0.5
	#var snapped_pos = false
	#var best_target: Control = null
	#var best_dist = INF
#
	## Find the closest valid block to snap onto
	#for child in get_children():
		#if child == new_block:
			#continue
		#if not child.has_meta("block_type"):
			#continue
		#var d = child.position.distance_to(at_position)
		#if d < best_dist:
			#best_dist = d
			#best_target = child
#
	## Define a threshold for snapping
	#var snap_threshold = 100.0
#
	#if best_target and best_dist < snap_threshold:
		#var target_type = best_target.get_meta("block_type")
#
		## Movement Blocks
		#if block_type in ["move_up", "move_down", "move_left", "move_right"]:
			## If nearest block is a loop with a block_container
			#if target_type in ["for_loop", "while_loop"] and best_target.has_method("get_block_container"):
				#var loop_body = best_target.get_block_container()
				#print("🔍 Found loop container:", loop_body, "with children:", loop_body.get_child_count())
#
				## Attach the new movement block inside the loop body
				#loop_body.add_child(new_block)
				#new_block.set_meta("block_type", block_type)
				#new_block.position = Vector2.ZERO
				#print("🔗 Movement block", block_type, "added inside loop container.")
#
				## Print updated loop body
				#print("📜 Updated loop body for", target_type, ": [", _get_loop_body_contents(loop_body), "]")
				#return
			#else:
				## Snap to the right of the nearest block
				#new_pos = best_target.position + Vector2(best_target.size.x - 22, 2)
				#snapped_pos = true
#
		## Loop Blocks
		#elif block_type in ["for_loop", "while_loop"]:
			#new_pos = best_target.position + Vector2(0, best_target.size.y - 10)
			#snapped_pos = true
#
		## Start Block (only one allowed)
		#elif block_type == "start":
			#print("❌ Drop rejected: Only one Start block allowed.")
			#new_block.queue_free()
			#return
#
	#else:
		## No valid target found—free drop only for a Start block
		#if block_type == "start":
			#new_block.position = new_pos
			#print("✅ Start block placed freely at:", new_block.position)
		#else:
			#print("❌ Drop rejected: Block must attach to an existing block in the chain.")
			#new_block.queue_free()
			#return
#
	## If we do a normal snap
	#if snapped_pos:
		#new_block.position = new_pos
		#print("✅ Block", block_type, "snapped to position:", new_block.position)
		
		



extends Panel

# Preload the scenes for each block type.
const FOR_LOOP_SCENE  = preload("res://Scenes/ForLoopItem.tscn")
const WHILE_LOOP_SCENE = preload("res://Scenes/WhileLoopItem.tscn")
const MOVEMENT_SCENE  = preload("res://Scenes/Item.tscn")
const START_SCENE = preload("res://Scenes/StartItem.tscn")

@onready var ICONS: Dictionary = {
	"move_up":    preload("res://Sprites/CodeBlockSprites/moveUp.png"),
	"move_down":  preload("res://Sprites/CodeBlockSprites/moveDown.png"),
	"move_left":  preload("res://Sprites/CodeBlockSprites/moveLeft.png"),
	"move_right": preload("res://Sprites/CodeBlockSprites/moveRight.png"),
	"start":      preload("res://Sprites/CodeBlockSprites/start.png"),
	"for_loop":   preload("res://Sprites/CodeBlockSprites/forLoop.png"),
	"while_loop": preload("res://Sprites/CodeBlockSprites/whileLoop.png")
}


func _ready():
	print("✅ DropZoneControl READY. I'm a Panel for dropping items.")
	
	var start_location = Vector2(42, 36)
	var start_data = {"block_type": "start", "texture": ICONS["start"]}
	
	if (_can_drop_data(start_location, start_data)):
		_drop_data(start_location, start_data);
	else:
		print("❌ ERROR: Can't add start block")
	# If you need to connect signals manually, do so here, or in the editor.


# -------------------------------------------------------------------
# Godot's default drop logic: rename to `can_drop_data`, `drop_data`
# if you rely on the engine's built-in mechanism. 
# Otherwise, connect them as signals.
# -------------------------------------------------------------------
func _can_drop_data(position: Vector2, data: Variant) -> bool:
	if data is Dictionary and data.has("block_type") and data.has("texture"):
		return true
	print("Rejected drop data in can_drop_data, not a valid dictionary:", data)
	return false


func _drop_data(at_position: Vector2, data: Variant) -> void:
	print('              ', at_position, data)	
	print("\n📥 DropZoneControl → _drop_data() called with data:", data)
	if not _can_drop_data(at_position, data):
		print("❌ ERROR: Invalid data dropped!")
		return

	var block_type = data["block_type"]
	var new_item: Control = null

	print(" → Attempting to instantiate block_type:", block_type)

	# 1. Instantiate
	match block_type:
		"for_loop":
			new_item = FOR_LOOP_SCENE.instantiate()
		"while_loop":
			new_item = WHILE_LOOP_SCENE.instantiate()
		"move_up", "move_down", "move_left", "move_right":
			new_item = MOVEMENT_SCENE.instantiate()
		"start":
			# Manually create a Start block
			new_item = HBoxContainer.new()
			new_item.custom_minimum_size = Vector2(70, 70)
			new_item.alignment = BoxContainer.ALIGNMENT_CENTER
			new_item.set_meta("block_type", "start")

			var icon = TextureRect.new()
			icon.texture = ICONS["start"]
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.custom_minimum_size = Vector2(70, 70)
			new_item.add_child(icon)
		_:
			print("⚠️ WARNING: Unrecognized block type!", block_type)
			return

	# 2. Check if scene instantiation worked
	if not new_item:
		print("❌ ERROR: Failed to instantiate node for block_type:", block_type)
		return

	# 3. Set the block_type property (if it exists) AND meta
	if "block_type" in new_item:
		print(" → Setting new_item.block_type =", block_type)
		new_item.block_type = block_type
	new_item.set_meta("block_type", block_type)

	# 4. Add to the AnswerArea (this Panel)
	add_child(new_item)
	new_item.position = at_position
	print(" → add_child() done. new_item name:", new_item.name,
		  "| position:", new_item.position,
		  "| child count in DropZone now:", get_child_count())

	# 5. If the only block in the drop zone is not "start", remove it
	if get_child_count() == 1 and block_type != "start":
		print("❌ Rejected drop: Must drop a 'Start' block first.")
		new_item.queue_free()
		return

	# 6. Finally, apply snapping logic
	_apply_snap_logic(new_item, block_type, at_position)


# -------------------------------------------------------------------
# For printing what's inside a loop's BlockContainer
# -------------------------------------------------------------------
func _get_loop_body_contents(loop_body: HBoxContainer) -> String:
	var body_contents = []
	for child in loop_body.get_children():
		print("     → Inspecting child in loop_body:", child, 
			  "| has_meta('block_type'):", child.has_meta("block_type"))
		if child.has_meta("block_type"):
			body_contents.append(child.get_meta("block_type"))
	return ", ".join(body_contents)


# -------------------------------------------------------------------
# Snap logic
# -------------------------------------------------------------------
func _apply_snap_logic(new_block: Control, block_type: String, at_position: Vector2) -> void:
	print("\n📍 _apply_snap_logic → Trying to place:", block_type, "at", at_position)

	# A) Check if a Start block exists
	var has_start = false
	for kid in get_children():
		if kid.has_meta("block_type") and kid.get_meta("block_type") == "start":
			has_start = true
			break
	if not has_start and block_type != "start":
		print("❌ No Start block found; can't place:", block_type)
		new_block.queue_free()
		return

	# B) Default (free) position
	var new_pos = at_position - new_block.custom_minimum_size * 0.5
	var snapped_pos = false

	# C) Find nearest existing block
	var best_target: Control = null
	var best_dist = INF
	for kid in get_children():
		if kid == new_block:
			continue
		if not kid.has_meta("block_type"):
			continue

		var dist = kid.position.distance_to(at_position)
		# Debug the distance
		print("   Checking target:", kid, 
			  "| block_type:", kid.get_meta("block_type"), 
			  "| dist:", dist)
		if dist < best_dist:
			best_dist = dist
			best_target = kid

	var snap_threshold = 100.0
	print(" → best_target is:", best_target, 
		  "| best_dist:", best_dist, 
		  "| snap_threshold:", snap_threshold)

	# D) Decide how to snap / re-parent
	if best_target and best_dist < snap_threshold:
		var target_type = best_target.get_meta("block_type")
		print(" → best_target has block_type:", target_type)

		# (i) Movement block inside for_loop/while_loop
		if block_type in ["move_up", "move_down", "move_left", "move_right"]:
			if target_type in ["for_loop", "while_loop"] and best_target.has_method("get_block_container"):
				print("   Found loop. Attempting to re-parent into its BlockContainer.")

				var loop_body = best_target.get_block_container()

				if loop_body:
					print("   ✅ loop_body found:", loop_body.name, 
						  "| Full path:", loop_body.get_path(),
						  "| Child count before adding:", loop_body.get_child_count())

					print("\t\tCall deferred for block:", new_block,
						  "| Parent before adding:", new_block.get_parent())

					print("\n🔄 FORCING IMMEDIATE RE-PARENTING...")
					
					#loop_body.call_deferred("add_child", new_block)
					
					# 🔴 Forcefully Remove the Block from Its Current Parent (If Any)
					if new_block.get_parent():
						new_block.get_parent().remove_child(new_block)

					# 🔴 Immediately Add It to BlockContainer
					loop_body.add_child(new_block)

					# 🔵 Force BlockContainer to Sort Layout in VBoxContainer
					loop_body.queue_sort()  # Ensure proper positioning

					# 🔴 Verify Parent Change
					await get_tree().process_frame  # Ensure re-parenting happens in the next frame
					print("\n✅ AFTER FORCED ADDING BLOCK — Parent now:", new_block.get_parent())
					print("   ✅ Now loop_body has children:", loop_body.get_child_count())

					for c in loop_body.get_children():
						print("       ➡️ Child:", c, "| has_meta('block_type'):", c.has_meta("block_type"))


					await get_tree().process_frame  # Ensure the add_child() operation finishes
					loop_body.queue_sort()  
					
					print("\n✅ AFTER ADDING BLOCK — Parent now:", new_block.get_parent())
					print("   ✅ Now loop_body has children:", loop_body.get_child_count())

					for c in loop_body.get_children():
						print("       ➡️ Child:", c, "| has_meta('block_type'):", c.has_meta("block_type"))

					# Reset the position to top-left in that VBoxContainer
					new_block.position = Vector2.ZERO
					new_block.set_meta("block_type", block_type)
					print("   → Movement block", block_type, "added inside loop container.")
					
					# Dump the children
					print("   Now loop_body has children:", loop_body.get_child_count())
					for c in loop_body.get_children():
						print("       ->", c, 
							  "| has_meta('block_type'):", c.has_meta("block_type"))

					# Print updated loop body
					var new_contents = _get_loop_body_contents(loop_body)
					print("📜 Updated loop body for", target_type, ": [", new_contents, "]")
					return
				else:
					print("❌ ERROR: best_target.get_block_container() returned null!")

			# If not a loop or no container
			print("   Snap to the right of nearest block instead.")
			snapped_pos = true
			new_pos = best_target.position + Vector2(best_target.size.x - 22, 2)

		# (ii) Loop blocks
		elif block_type in ["for_loop", "while_loop"]:
			print("   Snap a loop block below the nearest block.")
			snapped_pos = true
			new_pos = best_target.position + Vector2(0, best_target.size.y - 10)

		# (iii) Another Start block
		elif block_type == "start":
			print("❌ Already have a start block; removing the new one.")
			new_block.queue_free()
			return
	else:
		# E) If no valid target found — only allow free drop for 'start'
		if block_type == "start":
			print("   No best_target; placing start block freely at:", new_pos)
			new_block.position = new_pos
		else:
			print("❌ No valid block within snap range; removing:", block_type)
			new_block.queue_free()
			return

	# F) If we do a normal snap
	if snapped_pos:
		print("   Final snapped position for", block_type, "=", new_pos)
		new_block.position = new_pos
		print("✅ Block", block_type, "snapped to position:", new_block.position)
