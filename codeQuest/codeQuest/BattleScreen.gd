
extends CanvasLayer


signal battle_won
signal battle_lost

@export var challenge_text: String = """# Some incorrect code
print("Hello World)  # missing quote
"""
@export var correct_solution: String = """print("Hello World")"""

@export var time_limit: float = 30.0
var time_left: float


# Onready variables to ensure nodes exist before accessing them
@onready var text_edit = $Panel/TextEdit
@onready var timer = $Panel/Timer
@onready var submit_button = $Panel/Button
@onready var feedback_label = $Panel/Label2

func _ready() -> void:
	# Check if all required nodes exist before using them
	if not text_edit or not timer or not submit_button or not feedback_label:
		print("❌ ERROR: Missing UI elements in BattleScreen!")
		return  # Prevent further execution

	print("✅ BattleScreen loaded successfully!")

	# Set up initial UI state
	text_edit.text = challenge_text
	feedback_label.text = ""
	
	# Configure the timer
	time_left = time_limit
	timer.wait_time = time_limit
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()

	# Connect button signal
	submit_button.pressed.connect(_on_Button_pressed)

func _on_Timer_timeout() -> void:
	fail_battle()

func _on_Button_pressed() -> void:

	var player_solution = text_edit.text
	if _check_solution(player_solution):
		success_battle()
	else:
		feedback_label.text = "❌ Incorrect! Try again quickly."


func _check_solution(solution: String) -> bool:
	return solution.strip_edges() == correct_solution.strip_edges()

func success_battle() -> void:

	print("✅ Player solved the challenge!")

	emit_signal("battle_won")  
	queue_free()  # Remove the battle UI

func fail_battle() -> void:

	print("❌ Player failed the challenge!")

	emit_signal("battle_lost") 
	queue_free()  # Remove the battle UI
