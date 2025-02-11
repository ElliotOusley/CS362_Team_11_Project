extends Sprite2D

var list = []

func is_in_list(node) -> bool:
	return node in list

func addToList(node):
	if not is_in_list(node):
		list.append(node)
		arrangeList()
		
		print(list)

func removeFromList(node):
	if is_in_list(node):
		list.erase(node)
		arrangeList()
		
		print(list)

func resetPositions():
	arrangeList()

func arrangeList():
	if list.is_empty():
		return
	
	var start_rect = get_global_rect_for(self)
	var current_y = start_rect.end.y
	var start_x = start_rect.position.x
	var padding = 5
	
	for node in list:
		node.global_position = Vector2(start_x, current_y)
		var node_rect = node.get_global_rect()
		current_y = node_rect.end.y + padding

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
