extends GutTest

var gate: Area2D
var target_scene_instance: Node
var target_marker: Node2D
var player: Node2D
var save_path = "user://savegame.ini"
var target_scene_path = "res://Scenes/TargetScene.tscn"

func before_each():
	# Create the gate and target scene
	gate = Area2D.new()
	add_child(gate)
	
	# Load target scene and get marker
	target_scene_instance = load(target_scene_path).instantiate()
	target_marker = target_scene_instance.get_node("Marker2D")
	
	# Set the player position
	player = Node2D.new()
	player.position = Vector2(100, 100)  # Initial player position for testing
	
	# Add everything to the scene
	gate.add_child(player)
	get_tree().root.add_child(target_scene_instance)
	
	# Initialize exported values from gate script
	gate.marker_name = "Marker2D"
	gate.target_scene_path = target_scene_path

func after_each():
	if is_instance_valid(gate):
		gate.queue_free()
	if is_instance_valid(target_scene_instance):
		target_scene_instance.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	await get_tree().idle_frame  # Wait for the next idle frame to ensure cleanup is finished

func test_teleportation_on_scene_change():
	var marker = target_marker
	if marker:
		print("Marker position:", marker.global_position)
	
	gate.swap_level() # Test teleport
	
	# Check if player position and marker position match
	assert_eq(player.position, marker.global_position, "Player should be teleported to the marker position")

func test_scene_save_and_load():
	# Simulate teleportation and scene save
	gate.swap_level()
	
	var config = ConfigFile.new()
	if FileAccess.file_exists(save_path):
		config.load(save_path)
	
	# Check if the saved scene and player position are correct
	assert_eq(config.get_value("Player", "scene"), target_scene_path, "Saved scene path should match the target scene")
	assert_eq(config.get_value("Player", "position"), player.position, "Saved player position should match the player's current position")
