extends CharacterBody2D

@export var speed = 50
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
<<<<<<< HEAD:codeQuest/codeQuest/Scripts/Player Scripts/character_body_2d.gd
@onready var footstep_audio: AudioStreamPlayer2D = $footstep_audio
@export var inv: Inv
@onready var UI: CanvasLayer = $CanvasLayer
@onready var inventory_HUD = $CanvasLayer/InventoryUI

=======
>>>>>>> 3b7517a64e75a81c4c9a0fe68b4df5ff28aaf339:codeQuest/codeQuest/Scripts/character_body_2d.gd


var back_texture : Texture
var front_texture : Texture
var right_texture : Texture
var left_texture : Texture

var witch_nearby = false  # Flag to track if the Witch is near

func _ready():
	back_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Back.png")
	front_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Front.png")
	left_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Left.png")
	right_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Right.png")

func get_input():
	var input_direction = Vector2.ZERO

	# Check for interaction input (e.g., "Enter" key or gamepad button)
	if Input.is_action_just_pressed("ui_accept"):
		if witch_nearby:
			_start_battle_with_witch()
			return  # Stop movement while battle starts

		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			input_direction = Vector2.ZERO
			return
<<<<<<< HEAD:codeQuest/codeQuest/Scripts/Player Scripts/character_body_2d.gd
	if Input.is_action_just_pressed("Inventory"):
		inventory_HUD.visible = !inventory_HUD.visible #Making it toggleable
=======

>>>>>>> 3b7517a64e75a81c4c9a0fe68b4df5ff28aaf339:codeQuest/codeQuest/Scripts/character_body_2d.gd
	# Basic 4-directional movement
	if Input.is_action_pressed("up"):
		input_direction.y += -1
	if Input.is_action_pressed("down"):
		input_direction.y += 1
	if Input.is_action_pressed("left"):
		input_direction.x += -1
	if Input.is_action_pressed("right"):
		input_direction.x += 1
		
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)

	velocity = input_direction.normalized() * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	check_for_witch_collisions()  # Check if the Witch is nearby


# Checks if the Player is touching the Witch**
func check_for_witch_collisions():
	var bodies = actionable_finder.get_overlapping_bodies()
	witch_nearby = false  # Reset the flag

	for body in bodies:
		if body.name == "Witch":  # If the Witch is found
			print("hello")
			witch_nearby = true
			break  # No need to check further

# Starts the battle when Witch is near and Player interacts**
func _start_battle_with_witch():
	var main = get_tree().get_current_scene()  # Get the main scene
	if main and main.has_method("start_battle"):
		main.start_battle()  # Call start_battle() from Main.gd

<<<<<<< HEAD:codeQuest/codeQuest/Scripts/Player Scripts/character_body_2d.gd
# Timer timeout callback to play the footstep sound
func _on_timer_timeout():
	# Play the footstep sound if it's not already playing
	if !footstep_audio.playing:
		footstep_audio.pitch_scale = randf_range(0.8, 1.2)
		footstep_audio.play()
		
func collect(item):
	inv.insert(item)
=======
func player():
	pass
>>>>>>> 3b7517a64e75a81c4c9a0fe68b4df5ff28aaf339:codeQuest/codeQuest/Scripts/character_body_2d.gd
