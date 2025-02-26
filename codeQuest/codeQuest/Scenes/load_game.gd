extends Control

func _ready() -> void:
	$Menu/Continue.grab_focus()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_new_pressed() -> void:
	var save_path = "user://savegame.save"
	
	# Check if the save file exists and delete it
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("Save file deleted:", save_path)

	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
