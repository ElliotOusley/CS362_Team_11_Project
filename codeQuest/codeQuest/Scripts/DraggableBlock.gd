#extends TextureRect
#
#var dragging: bool = false
#var drag_offset: Vector2 = Vector2.ZERO
#
#func _gui_input(event):
	## Left-click: start/stop dragging.
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#dragging = true
			#drag_offset = event.position
		#else:
			#dragging = false
	## Right-click: remove the block (but don’t allow deletion of the "start" block).
	#elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		#if has_meta("block_type") and get_meta("block_type") == "start":
			#return  # Do not delete the start block.
		#queue_free()
	## While dragging, update the block's position.
	#elif event is InputEventMouseMotion and dragging:
		#position += event.relative


extends TextureRect

var drag_offset = Vector2.ZERO

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			drag_offset = event.position
			grab_focus()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			release_focus()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			queue_free()
	if event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_LEFT) != 0:
		global_position += (event.position - drag_offset)
