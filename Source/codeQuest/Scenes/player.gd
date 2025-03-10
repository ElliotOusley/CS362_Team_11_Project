extends Node2D

@export var inv: Inv
@export var attack_damage: int = 20  # Added attack_damage variable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Attack function to deal damage to a target
func attack(target):
	if target.has_method("take_damage"):  # Check if target has take_damage method
		target.take_damage(attack_damage)
