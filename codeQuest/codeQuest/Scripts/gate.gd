extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var marker_name: String = "Marker2D"  # Name of the marker where the player will teleport

var player: Node2D = null
var teleport_after_load = false

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if get_overlapping_bodies().size() >= 1:
			swap_level()

func swap_level():
	print("SWAP LEVEL")

	if not target_scene_path:
		print("No scene path specified!")
		return

	var scene_to_load = load(target_scene_path) as PackedScene
	if not scene_to_load:
		print("Failed to load scene from path: ", target_scene_path)
		return

	teleport_after_load = true
	var result = get_tree().change_scene_to_packed(scene_to_load)
	if result != OK:
		print("Scene change failed!")
		teleport_after_load = false
	else:
		print("Scene change succeeded!")

func _on_scene_changed():
	print("ON SCENE CHANGED")
	if teleport_after_load:
		teleport_after_load = false
		teleport_player()

func teleport_player():
	print("Attempting to teleport player")
	var current_scene = get_tree().current_scene
	if current_scene == null:
		print("Scene not fully loaded yet.")
		return

	player = current_scene.find_child("Player", true)
	if player == null:
		print("Player node not found.")
		return

	var marker = current_scene.find_child(marker_name, true)
	if marker:
		player.position = marker.position
		print("Player teleported to marker.")
	else:
		print("Marker2D node not found in the target scene")
