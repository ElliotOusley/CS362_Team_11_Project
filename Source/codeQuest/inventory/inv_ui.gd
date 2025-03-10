# Creates and updates UI display for an inv object, as described in inv.gd.
extends Control

@onready var inv: Inv = preload("res://inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

# Runs on UI creation.
func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

# Update appearance of inventory.
func update_slots ():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
# Uses open and close functions to make inventory UI appear and dissapear
# on button press.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
