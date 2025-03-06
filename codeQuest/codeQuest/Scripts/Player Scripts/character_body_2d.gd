extends CharacterBody2D
class_name PlayerCharacter

@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var footstep_audio: AudioStreamPlayer2D = $footstep_audio
@onready var UI: CanvasLayer = $CanvasLayer
@onready var inventory_HUD = $CanvasLayer/InventoryUI

@export var inv: Inv
@export var speed = 50



var back_texture : Texture
var front_texture : Texture
var right_texture : Texture
var left_texture : Texture
var timer : Timer

var witch_nearby = false  # Flag to track if the Witch is near

var save_path = "user://savegame.ini"

const INV_ITEMS = {
	"potion": preload("res://inventory/Items/potion.tres")
}

func _ready():
	# Create and configure the timer
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2  # Set the interval to 0.2 seconds
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	if inventory_HUD:
		inventory_HUD.visible = false # Hiding the inventory UI
		
	if FileAccess.file_exists(save_path):
		var config = ConfigFile.new()
		config.load(save_path)

		var pos = config.get_value("Player", "position", Vector2.ZERO)

		position = pos

		var item_names = config.get_value("Player", "item_names", [])
		var item_amounts = config.get_value("Player", "item_amounts", [])

		for i in range(item_names.size()):
			var item_name = item_names[i]
			var item_amount = item_amounts[i]

			if INV_ITEMS.has(item_name):
				var item = INV_ITEMS[item_name].duplicate()
				inv.insert(item, item_amount)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_PREDELETE:
		save_position()
		save_items()


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
		
# Add item to player inventory.
func collect(item):
	inv.insert(item)

func save_position() -> void:
	var config = ConfigFile.new()
	if FileAccess.file_exists(save_path):
		config.load(save_path)

	# Save the player's position
	config.set_value("Player", "position", position)

	config.save(save_path)

func save_items() -> void:
	var slots = inv.get_slots()
	
	var item_names = []
	var item_amounts = []
	for slot in slots:
		if slot.item:
			item_names.append(slot.item.name)
			item_amounts.append(slot.amount)
		

	var config = ConfigFile.new()
	if FileAccess.file_exists(save_path):
		config.load(save_path)

	config.set_value("Player", "item_names", item_names)
	config.set_value("Player", "item_amounts", item_amounts)
	
	config.save(save_path)
