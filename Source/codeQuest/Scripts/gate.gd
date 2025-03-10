extends Area2D

@export var marker_name: String = "Marker2D"  # Specify the name of a marker in the target scene
@export_file("*.tscn") var target_scene_path: String

# Variable to hold the player node for later teleportation
var player: Node2D = null

# Delay teleportation until the scene is fully loaded
var teleport_after_load = false

var target_scene: PackedScene

var save_path = "user://savegame.ini"

func _ready() -> void:
	target_scene = load(target_scene_path)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !target_scene:
			print("No scene specified for current gate")
			return
		if get_overlapping_bodies().size() >= 1:
			swap_level()

func swap_level():
	var target_scene_instance = target_scene.instantiate()
	
	var marker = target_scene_instance.get_node_or_null(marker_name)
	
	if marker:
		print("Marker position: ", marker.global_position)
		var current_scene = get_tree().current_scene
		player = current_scene.get_node_or_null("Ysort/Player")
		if player:
			player.position = marker.global_position
			print("Player teleported to marker.")
	
	print("SWAP LEVEL")
	var result = get_tree().change_scene_to_packed(target_scene)
	if result != OK:
		print("Scene change failed!")
	else:
		print("Scene change succeeded!")
		teleport_after_load = true

	var config = ConfigFile.new()
		
	if FileAccess.file_exists(save_path):
		config.load(save_path)

	config.set_value("Player", "scene", target_scene_path)
	config.set_value("Player", "position", player.position)

	config.save(save_path)
