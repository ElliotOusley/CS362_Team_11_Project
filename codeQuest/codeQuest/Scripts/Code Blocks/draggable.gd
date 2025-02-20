# draggable.gd
class_name Draggable
extends Node2D

@export var is_draggable = true

var dragging = false
var drag_offset = Vector2()

var old_position = Vector2()

func _input(event: InputEvent) -> void:
	if not is_draggable:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_global_rect().has_point(event.position):
				dragging = true
				drag_offset = global_position - event.position
				z_index = 5

				get_viewport().set_input_as_handled()
		else:
			if dragging:
				dragging = false
				z_index = 0

				if get_parent() is Attachable:
					if global_position.distance_to(old_position) > 20:
						get_parent().remove_from_list(self)
					else:
						get_parent().reset_position()
				else:
					check_overlapping_sprites()

				old_position = global_position
	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset

func check_overlapping_sprites() -> void:
	var root = get_tree().get_root().get_child(0)
	var current_rect = get_global_rect()

	for sprite in root.get_children():
		if sprite == self:
			continue
		if sprite is Attachable:
			var sprite_rect = sprite.get_global_rect()
			if current_rect.intersects(sprite_rect):
				print(name, " is overlapping with ", sprite.name)
				sprite.add_to_list(self)

func get_global_rect() -> Rect2:
	for child in get_children():
		if child is CanvasItem:
			var rect = get_global_rect_for(child)
			if rect.size != Vector2.ZERO:
				return rect
	return Rect2(global_position, Vector2.ZERO)

func get_global_rect_for(item: Node2D) -> Rect2:
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
