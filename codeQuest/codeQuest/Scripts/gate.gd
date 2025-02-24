extends Area2D

@export var target_scene: PackedScene
@export var marker_name: String = "Marker2D"  # Specify the name of a marker in the target scene
signal target_scene_loaded

func _ready() -> void:
	connect("target_scene_loaded", Callable(self, "teleport_player"))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !target_scene:  # If a target scene is not specified, do nothing
			print("No scene specified for current gate")
			return
		if get_overlapping_bodies().size() >= 1:  # If the player's hitbox overlaps with the gate
			swap_level()

func swap_level():
	var result = await(get_tree().change_scene_to_packed(target_scene)) 
	if result != OK:
		print("Scene change failed!")  # Debug
	else:
		print("Scene change succeeded!")  # Debug
		
		#teleport_player() # NOT WORKING


func teleport_player(): # Currently nonfunctional, need to find a way to wait for level to load
	if get_tree().current_scene == null:
		print("Scene not fully loaded yet.")
		return
		
	var player = get_tree().current_scene.get_node("Player")
	
	var marker = get_tree().current_scene.get_node(marker_name)
	
	if marker:  # If the marker node exists
		player.position = marker.position  # Move player to marker position
	else:
		print("Marker2D node not found in the target scene")
