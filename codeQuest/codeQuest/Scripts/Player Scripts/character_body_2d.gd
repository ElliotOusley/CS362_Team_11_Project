extends CharacterBody2D
class_name PlayerCharacter

@export var speed = 50
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var footstep_audio: AudioStreamPlayer2D = $footstep_audio
@export var inv: Inv
@onready var UI: CanvasLayer = $CanvasLayer
@onready var inventory_HUD = $CanvasLayer/InventoryUI




var back_texture : Texture
var front_texture : Texture
var right_texture : Texture
var left_texture : Texture
var timer : Timer

var witch_nearby = false  # Flag to track if the Witch is near

var save_path = "user://savegame.save"

func _ready():
	print("Footstep Audio:", footstep_audio)
	
	
	# Create and configure the timer
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2  # Set the interval to 0.2 seconds
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	if inventory_HUD:
		inventory_HUD.visible = false # Hiding the inventory UI
		
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var saved_position = file.get_var()
			if saved_position is Vector2:
				position = saved_position  # Set player's position
				
			file.close()
		print("Loaded position:", position)
		
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_PREDELETE:
		save_position()


func get_input():
	var input_direction = Vector2.ZERO
	var moving = false
	
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
	if Input.is_action_just_pressed("Inventory"):
		inventory_HUD.visible = !inventory_HUD.visible #Making it toggleable
	# Basic 4-directional movement
	if Input.is_action_pressed("up"):
		input_direction.y += -1
		moving = true
	if Input.is_action_pressed("down"):
		input_direction.y += 1
		moving = true
	if Input.is_action_pressed("left"):
		input_direction.x += -1
		moving = true
	if Input.is_action_pressed("right"):
		input_direction.x += 1
		moving = true

	if moving and timer.is_stopped():
		timer.start()
	
	if not moving and timer.time_left > 0:
		timer.stop()
		footstep_audio.stop()


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
			witch_nearby = true
			break  # No need to check further

# Starts the battle when Witch is near and Player interacts**
func _start_battle_with_witch():
	var main = get_tree().get_current_scene()  # Get the main scene
	if main and main.has_method("start_battle"):
		main.start_battle()  # Call start_battle() from Main.gd

# Timer timeout callback to play the footstep sound
func _on_timer_timeout():
	# Play the footstep sound if it's not already playing
	if !footstep_audio.playing:
		footstep_audio.pitch_scale = randf_range(0.8, 1.2)
		footstep_audio.play()
		
#
func collect(item):
	inv.insert(item)

func save_position() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(position)  # Save player's position
		file.close()
		print("Saved position:", position)
