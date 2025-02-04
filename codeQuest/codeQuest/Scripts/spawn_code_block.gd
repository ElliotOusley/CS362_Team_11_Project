class_name SpawnCodeBlock
extends Sprite2D

@export var draggable_scene: PackedScene

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if get_rect().has_point(to_local(event.position)):
				if draggable_scene:
					var instance = draggable_scene.instantiate()
					get_parent().add_child(instance)
					instance.global_position = event.position
				else:
					print("Draggable scene is not assigned!")
