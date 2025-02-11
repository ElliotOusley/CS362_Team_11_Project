extends HBoxContainer

enum modes {SIMPLE, EMPTY, PARTIAL}

var heart_full = preload("res://Sprites/UI/Full_Health_Heart.png")
var heart_half = preload("res://Sprites/UI/Half_Health_Heart.png")
var heart_empty = preload("res://Sprites/UI/Empty_Health_Heart.png")

@export var mode : modes
# Called when the node enters the scene tree for the first time.

@export var max_health = 0

var value : int

func _ready() -> void:
	value = max_health
	print(max_health)
	print(value)


func update_health(value):
	match mode:
		modes.SIMPLE:
			update_simple(value)
		modes.EMPTY:
			update_empty(value)
		modes.PARTIAL:
			update_partial(value)
	update_health_text(value)

func update_simple(value):
	for i in get_child_count():
		get_child(i).visible = value > i
		
func update_empty(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty
			
func update_partial(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty


func _on_add_health_pressed() -> void:
	print("Adding health, current value is ", value)
	if value < max_health:
		value += 1
		update_health(value)


func _on_remove_health_pressed() -> void:
	print(value)
	if value > 0:
		value -= 1
		update_health(value)
		
func update_health_text(value):
	var label = $"../../Current Health"
	label.text = "Current Health: %d" %[value]
