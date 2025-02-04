extends Control

signal battle_won
signal battle_lost

@export var challenge_text: String = """# Some incorrect code
print("Hello World)  # missing quote
"""
@export var correct_solution: String = """print("Hello World")"""

@export var time_limit: float = 30.0
var time_left: float

func _ready() -> void:
	$TextEdit.text = challenge_text
	time_left = time_limit
	$Timer.wait_time = time_limit
	$Timer.start()

func _on_Timer_timeout() -> void:
	fail_battle()

func _on_Button_pressed() -> void:
	var player_solution = $TextEdit.text
	if _check_solution(player_solution):
		success_battle()
	else:
		$Label2.text = "Incorrect! Try again quickly."

func _check_solution(solution: String) -> bool:
	return solution.strip_edges() == correct_solution.strip_edges()

func success_battle() -> void:
	emit_signal("battle_won")  
	queue_free()  # Remove the battle UI

func fail_battle() -> void:
	emit_signal("battle_lost") 
	queue_free()  # Remove the battle UI
