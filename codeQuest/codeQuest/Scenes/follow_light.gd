extends Node2D

@export var target: Witch
@export var follow_distance = 20.0
@export var follow_speed: = 40.0
@export var threshold_distance = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play() # Start the animation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	calculate_velocity(delta)


func calculate_velocity(delta):
	var target_position = target.position # Get the target's position
	var offset = Vector2(follow_distance, 0) # Puts follow position to the left the target
	var desired_position = (target_position + offset) # Locate the desired position
	
	var direction = (desired_position - position).normalized()
	var distance_to_target = position.distance_to(desired_position)
	
	# Prevents light from trying to move when it is already in position
	if distance_to_target > threshold_distance: 
		position += direction * follow_speed * delta
