# attachable.gd
class_name Attachable
extends Draggable

func _ready() -> void:
	print("attachable redy")

var list = []

func is_in_list(node) -> bool:
	return node in list

func add_to_list(node: Draggable):
	if not is_in_list(node):
		list.append(node)
		node.get_parent().remove_child(node)
		self.add_child(node)
		arrange_list()
		
		print(list)

func remove_from_list(node):
	if is_in_list(node):
		list.erase(node)
		arrange_list()
		self.remove_child(node)
		get_tree().get_root().get_child(0).add_child(node)
		
		print(list)

func reset_position():
	arrange_list()

func arrange_list():
	if list.is_empty():
		return
	
	# Get the bounding box of the Attachable node
	var start_rect = get_global_rect()
	var current_y = start_rect.end.y + 5  # Start below with padding
	var start_x = start_rect.position.x
	
	# Space out each draggable object
	for node in list:
		if node is Draggable:
			node.global_position = Vector2(start_x, current_y)
			var node_rect = node.get_global_rect()
			current_y = node_rect.end.y + 5  # Move down for the next object

func get_global_rect() -> Rect2:
	for child in get_children():
		if child is Sprite2D:
			var texture = child.texture
			if texture:
				var size = texture.get_size() * child.scale
				var pos = child.global_position - (size * 0.5)
				return Rect2(pos, size)
		elif child is Control:  # Handle UI elements like TextureRect
			return Rect2(child.global_position, child.size)
	
	return Rect2(global_position, Vector2.ZERO)
	
