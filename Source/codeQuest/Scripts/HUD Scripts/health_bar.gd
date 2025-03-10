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


func update_health(new_value):
	if new_value <= 0:
		print("dead")
	
	value = new_value
	
	match mode:
		modes.SIMPLE:
			update_simple(new_value)
		modes.EMPTY:
			update_empty(new_value)
		modes.PARTIAL:
			update_partial(new_value)
	update_health_text(new_value)

func update_simple(new_value):
	for i in get_child_count():
		get_child(i).visible = new_value > i
		
func update_empty(new_value):
	for i in get_child_count():
		if new_value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty
			
func update_partial(new_value):
	for i in get_child_count():
		if new_value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif new_value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty

func increase_health(amount):
	update_health(value + amount)

func decrease_health(amount):
	update_health(value - amount)

func _on_add_health_pressed() -> void:
	print("Adding health, current value is ", value)
	if value < max_health:
		update_health(value + 1)


func _on_remove_health_pressed() -> void:
	print(value)
	update_health(value - 1)
		
func update_health_text(new_value):
	var label = $"../../Current Health"
	label.text = "Current Health: %d" %[new_value]
