extends CharacterBody2D

@export var roam_radius: float = 100.0
@export var move_speed: float = 20.0
@export var change_target_time: float = 2.0
@export var stop_time: float = 1.0  # Time to stop after each move

var _origin_position: Vector2
var _target_position: Vector2
var _time_passed: float = 0.0
var _is_stopped: bool = true
var _stop_timer: float = 0.0

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
			return
	
	_time_passed += delta
	if _time_passed >= change_target_time:
		_pick_new_target()
		_time_passed = 0.0
		_is_stopped = true
		return

	var direction = (_target_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	if global_position.distance_to(_target_position) < 10:
		_pick_new_target()
		_is_stopped = true

func _pick_new_target() -> void:
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	var direction = directions[randi() % directions.size()]
	var distance = randf() * roam_radius
	_target_position = _origin_position + (direction * distance)
