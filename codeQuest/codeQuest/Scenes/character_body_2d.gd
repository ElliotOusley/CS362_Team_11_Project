extends CharacterBody2D

@export var speed = 50

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
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	change_sprite()

func _physics_process(delta):
	get_input()
	move_and_slide()

func change_sprite():

	if Input.is_action_just_pressed("left"):
		$Sprite2D.texture = left_texture
	if Input.is_action_just_pressed("right"):
		$Sprite2D.texture = right_texture
	if Input.is_action_just_pressed("up"):
		$Sprite2D.texture = back_texture
	if Input.is_action_just_pressed("down"):
		$Sprite2D.texture = front_texture
