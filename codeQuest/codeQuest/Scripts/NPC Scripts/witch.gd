extends CharacterBody2D
class_name Witch

@export var roam_radius: float = 100.0
@export var move_speed: float = 20.0
@export var change_target_time: float = 2.0
@export var stop_time: float = 1.0  # Time to stop after each move
@export var health: int = 100  # Ensure health is defined

var _origin_position: Vector2
var _target_position: Vector2
var _time_passed: float = 0.0
var _is_stopped: bool = true
var _stop_timer: float = 0.0
var _direction: Vector2 = Vector2.ZERO  # Stores the current movement direction

@onready var animation_player: AnimationPlayer = $Sprite2D/witchAnimation

func _ready() -> void:
	_origin_position = global_position
	_pick_new_target()

func _physics_process(delta: float) -> void:
	if _is_stopped:
		_stop_timer += delta
		if _stop_timer >= stop_time:
			_is_stopped = false
			_stop_timer = 0.0
		else:
			velocity = Vector2.ZERO
			animation_player.stop()  # Stop animation when idle
			return
	
	_time_passed += delta
	if _time_passed >= change_target_time:
		_pick_new_target()
		_time_passed = 0.0
		_is_stopped = true
		return

	# Ensure the witch moves strictly in ONE direction at a time
	if _direction == Vector2.UP or _direction == Vector2.DOWN:
		velocity = Vector2(0, _direction.y * move_speed)  # X is always 0
	elif _direction == Vector2.LEFT or _direction == Vector2.RIGHT:
		velocity = Vector2(_direction.x * move_speed, 0)  # Y is always 0

	# Play the correct movement animation
	_play_movement_animation(_direction)

	move_and_slide()

	# If the witch reaches the target position, pick a new target
	if global_position.distance_to(_target_position) < 10:
		_pick_new_target()
		_is_stopped = true

func _pick_new_target() -> void:
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	_direction = directions[randi() % directions.size()]  # Pick a random direction
	var distance = randf() * roam_radius
	_target_position = _origin_position + (_direction * distance)

func _play_movement_animation(direction: Vector2) -> void:
	if direction == Vector2.UP:
		animation_player.play("walkup")
	elif direction == Vector2.DOWN:
		animation_player.play("walkdown")
	elif direction == Vector2.LEFT:
		animation_player.play("walkleft")
	elif direction == Vector2.RIGHT:
		animation_player.play("walkright")

# Add take_damage() to modify health
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()  # Remove the witch if health reaches 0
