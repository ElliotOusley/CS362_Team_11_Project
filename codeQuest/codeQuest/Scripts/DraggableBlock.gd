extends Control

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
