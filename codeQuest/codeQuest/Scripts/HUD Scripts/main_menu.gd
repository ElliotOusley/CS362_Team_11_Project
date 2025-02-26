extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Menu/StartButton.grab_focus()

	print("Save file path: ", ProjectSettings.globalize_path("user://savegame.save"))


func _on_start_button_pressed() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	if save_file:
		save_file.close()
		
		get_tree().change_scene_to_file("res://Scenes/LoadGame.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
