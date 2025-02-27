extends Control

var save_path = "user://savegame.ini"

func _ready() -> void:
	$Menu/Continue.grab_focus()

func _on_continue_pressed() -> void:
	if FileAccess.file_exists(save_path):
		var config = ConfigFile.new()
		config.load(save_path)
		
		var scene = config.get_value("Player", "scene", "res://Scenes/Main.tscn")
		
		get_tree().change_scene_to_file(scene)
	else:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_new_pressed() -> void:
	# Check if the save file exists and delete it
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)

	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
