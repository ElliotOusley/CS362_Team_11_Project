extends CharacterBody2D

@export var speed = 50
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

var back_texture : Texture
var front_texture : Texture
var right_texture : Texture
var left_texture : Texture

func _ready():
	back_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Back.png")
	front_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Front.png")
	left_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Left.png")
	right_texture = preload("res://Sprites/Characters/Red_Wizard/Red_Wizard_Right.png")

func get_input():
	var input_direction = Vector2.ZERO
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			input_direction = Vector2.ZERO
			return
	
	#If statements allow for 4-directional movement
	#No diagonals allowed
	if Input.is_action_pressed("up"):
		input_direction.y = -1
	if Input.is_action_pressed("down"):
		input_direction.y = 1
	if Input.is_action_pressed("left"):
		input_direction.x = -1
	if Input.is_action_pressed("right"):
		input_direction.x = 1
		
	velocity = input_direction.normalized() * speed
	change_sprite()

func _physics_process(delta):
	get_input()
	move_and_slide()

#Uses player velocity to change moving sprites
func change_sprite():
	if velocity.x < 0:
		$Sprite2D.texture = left_texture
	elif velocity.x > 0:
		$Sprite2D.texture = right_texture
	elif velocity.y < 0:
		$Sprite2D.texture = back_texture
	elif velocity.y > 0:
		$Sprite2D.texture = front_texture
