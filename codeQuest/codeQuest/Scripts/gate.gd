extends Area2D

@export var target_scene: PackedScene
@export var marker_name: String = "Marker2D"  # Specify the name of a marker in the target scene

# Variable to hold the player node for later teleportation
var player: Node2D = null

# Delay teleportation until the scene is fully loaded
var teleport_after_load = false

func _ready() -> void:
	# This ensures we connect the signal for the *current* scene change
	get_tree().connect("scene_changed", Callable(self, "_on_scene_changed"))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !target_scene:  # If a target scene is not specified, do nothing
			print("No scene specified for current gate")
			return
		if get_overlapping_bodies().size() >= 1:  # If the player's hitbox overlaps with the gate
			teleport_player()
			swap_level()

func swap_level():
	print("SWAP LEVEL")
	var result = get_tree().change_scene_to_packed(target_scene)
	if result != OK:
		print("Scene change failed!")  # Debug
	else:
		print("Scene change succeeded!")  # Debug
		teleport_after_load = true
		# No need to connect here. The signal is already connected in _ready().

func _on_scene_changed():
	print("ON SCENE CHANGED")
	# This function will be called when the scene is finished loading
	if teleport_after_load:
		teleport_after_load = false
		teleport_player()

func teleport_player(): 
	print("Attempting to teleport player")
	var current_scene = get_tree().current_scene
	if current_scene == null:
		print("Scene not fully loaded yet.")
		return

	# Wait until the player node is available in the new scene
	player = current_scene.get_node("Ysort/Player")
	if player == null:
		print("Player node not found.")
		return

	# Wait until the marker node is available in the new scene
	var marker = current_scene.get_node(marker_name)
	if marker:
		player.position = marker.position  # Move player to marker position
		print("Player teleported to marker.")
	else:
		print("Marker2D node not found in the target scene")
