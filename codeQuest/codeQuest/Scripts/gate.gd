extends Area2D

@export var target_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !target_scene: # If a target scene is not specified, do nothing
			print("No scene specified for current gate")
			return
		if get_overlapping_bodies().size() >= 1: # If the player's hitbox overlaps with the gate
			swap_level()

func swap_level():
	var success = get_tree().change_scene_to_packed(target_scene)
	
	if success != OK: # If changing scene fails, print error message to console
		print("Changing scene failed")
