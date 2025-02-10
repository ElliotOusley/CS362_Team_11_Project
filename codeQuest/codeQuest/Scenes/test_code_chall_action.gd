extends Area2D


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action() -> void:
	get_tree().change_scene_to_file("res://Scenes/TestCodeChallange/TestCodeChallenge.tscn")
