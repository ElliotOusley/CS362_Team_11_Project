extends CharacterBody2D

@export var roam_radius: float = 100.0
@export var move_speed: float = 20.0

# This is how often the Witch will pick a new random target, in seconds.
@export var change_target_time: float = 2.0

var _origin_position: Vector2
var _target_position: Vector2
var _time_passed: float = 0.0

var player
var is_player_colliding = false

func _ready() -> void:
	# Record the Witch’s initial position as the center of her roaming circle.
	_origin_position = global_position
	# Pick the first random target right away.
	_pick_new_target()

	# Optionally, connect signals here if you prefer signals for collision.
	# Or we can just rely on checking overlap from the Player side.
	# For example:
	# $CollisionShape2D.connect("body_entered", self, "_on_body_entered")

func _process(_delta: float) -> void:
	if is_player_colliding and Input.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/ChallangeOne/ChallangeOne.tscn")

func _physics_process(delta: float) -> void:
	# Count up time and pick a new target from time to time.
	_time_passed += delta
	if _time_passed >= change_target_time:
		_pick_new_target()
		_time_passed = 0.0

	# Move toward the current _target_position.
	var direction = (_target_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# If we are close to the target, pick a new one immediately (optional).
	if global_position.distance_to(_target_position) < 10:
		_pick_new_target()

func _pick_new_target() -> void:
	# Pick a random angle and random distance within roam_radius.
	var angle = randf() * TAU
	var distance = randf() * roam_radius
	var offset = Vector2(distance, 0).rotated(angle)
	_target_position = _origin_position + offset

# Optionally, if you want direct collision detection via signals:
# func _on_body_entered(body: Node) -> void:
#     if body.name == "Player":
#         _start_battle()
# 
# func _start_battle():
#     # We'll show how to do the "battle" next.
#     pass




func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		move_speed = 0.0
		is_player_colliding = true
		$InteractLabel.visible = true
		


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		move_speed = 20.0
		is_player_colliding = false
		$InteractLabel.visible = false
