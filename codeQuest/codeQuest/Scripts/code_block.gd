class_name CodeBlock
extends Node2D

var dragging = false
var drag_offset = Vector2()
var original_position = Vector2.ZERO
var start_sprite: Sprite2D

func _ready():
	var parent = get_parent()
	if parent:
		for child in parent.get_children():
			if child is Sprite2D and child.name == "StartBlock":
				start_sprite = child
				break

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var mouse_pos = event.position
			if get_global_rect().has_point(mouse_pos):
				dragging = true
				drag_offset = global_position - mouse_pos
				if start_sprite and start_sprite.is_in_list(self):
					original_position = global_position
				get_viewport().set_input_as_handled()
		else:
			if dragging:
				handle_drop()
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset

func handle_drop():
	if start_sprite and original_position != Vector2.ZERO:
		var distance = original_position.distance_to(global_position)
		if distance > 20:
			start_sprite.removeFromList(self)
		else:
			start_sprite.resetPositions()
		original_position = Vector2.ZERO
	
	# Check if we need to add back to list
	if start_sprite:
		var my_rect = get_global_rect()
		var start_rect = get_global_rect_for(start_sprite)
		if my_rect.intersects(start_rect):
			start_sprite.addToList(self)

func get_global_rect() -> Rect2:
	for child in get_children():
		if child is CanvasItem:
			var rect = get_global_rect_for(child)
			if rect.size != Vector2.ZERO:
				return rect
	return Rect2(global_position, Vector2.ZERO)

func get_global_rect_for(item: CanvasItem) -> Rect2:
	var rect = item.get_rect()
	if rect.size == Vector2.ZERO:
		return Rect2(item.global_position, Vector2.ZERO)
	var xform = item.get_global_transform()
	var points = [
		xform * rect.position,
		xform * Vector2(rect.end.x, rect.position.y),
		xform * rect.end,
		xform * Vector2(rect.position.x, rect.end.y)
	]
	var min_point = points[0]
	var max_point = points[0]
	for p in points:
		min_point = min_point.min(p)
		max_point = max_point.max(p)
	return Rect2(min_point, max_point - min_point)
