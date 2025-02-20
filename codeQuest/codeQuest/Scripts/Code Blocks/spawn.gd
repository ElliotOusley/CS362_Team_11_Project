# spawn.gd
extends Sprite2D
class_name Spawn

@export var draggable: PackedScene;

func _input(event: InputEvent) -> void:
	if !draggable:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if get_rect().has_point(to_local(event.position)):
				var instance = draggable.instantiate()  # Create an instance of the draggable scene
				get_tree().get_root().get_child(0).add_child(instance)  # Add it to the parent node
				instance.global_position = event.position  # Set position to the mouse click location
