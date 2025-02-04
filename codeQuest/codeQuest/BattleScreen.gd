extends CanvasLayer

signal battle_won
signal battle_lost

# A list of coding challenges, each is a Dictionary with two keys:
# "challenge_text" and "correct_solution".
# You can add as many as you want (we have 12 here).
var all_challenges := [
	{
		"challenge_text": """# 1) Fix this Python print statement:
print("Hello World) # missing quote
""",
		"correct_solution": """print("Hello World")"""
	},
	{
		"challenge_text": """# 2) Fix the variable assignment in GDScript:
var number = 10
var total = number + "5" # This line is incorrect
""",
		"correct_solution": """var number = 10
var total = number + 5"""
	},
	{
		"challenge_text": """# 3) Fix the JavaScript console.log statement:
console.log("Hello World); // missing quote
""",
		"correct_solution": """console.log("Hello World");"""
	},
	{
		"challenge_text": """# 4) Fix the C# main method signature:
public static void main(String[] args){
	Console.WriteLine("Hello");
}
""",
		"correct_solution": """public static void Main(string[] args){
	Console.WriteLine("Hello");
}"""
	},
	{
		"challenge_text": """# 5) Fix the HTML element:
<a href="www.example.com>Click me!</a>
""",
		"correct_solution": """<a href="www.example.com">Click me!</a>"""
	},
	{
		"challenge_text": """# 6) Fix the JSON structure:
{
  "name": "Alice",
  "age": 30,
  "city": "Wonderland"
""",
		"correct_solution": """{
  "name": "Alice",
  "age": 30,
  "city": "Wonderland"
}"""
	},
	{
		"challenge_text": """# 7) Fix the trailing comma in JavaScript object:
let person = {
  name: "Bob",
  age: 25,
};
""",
		"correct_solution": """let person = {
  name: "Bob",
  age: 25
};"""
	},
	{
		"challenge_text": """# 8) Fix the Python indent error:
def greet():
print("Hello")
""",
		"correct_solution": """def greet():
	print("Hello")"""
	},
	{
		"challenge_text": """# 9) Fix this unclosed tag in HTML:
<div>
  <p>Hello world</p>
""",
		"correct_solution": """<div>
  <p>Hello world</p>
</div>"""
	},
	{
		"challenge_text": """# 10) Fix the missing semicolon in C++:
#include <iostream>
int main() {
	std::cout << "Hello" 
	return 0;
}
""",
		"correct_solution": """#include <iostream>
int main() {
	std::cout << "Hello";
	return 0;
}"""
	},
	{
		"challenge_text": """# 11) Fix the missing curly brace in GDScript function:
func test_something():
	print("Start")
	print("End")
""",
		"correct_solution": """func test_something():
	print("Start")
	print("End")"""
	},
	{
		"challenge_text": """# 12) Fix the Lua function:
function greet()
print("Hello")
""",
		"correct_solution": """function greet()
  print("Hello")
end"""
	}
]

@export var time_limit: float = 60.0  # total time to solve all 3 challenges
@export var total_lives: int = 3     # total incorrect attempts allowed

# We'll pick 3 random challenges from the list above
var selected_challenges: Array = []
var current_challenge_index: int = 0
var current_lives: int
var time_left: float

@onready var challenge_label = $Panel/ChallengeLabel
@onready var text_edit       = $Panel/TextEdit
@onready var submit_button   = $Panel/SubmitButton
@onready var feedback_label  = $Panel/FeedbackLabel
@onready var timer           = $Panel/Timer
@onready var timer_label     = $Panel/TimerLabel

func _ready():
	# 1) Safety checks
	if not challenge_label or not text_edit or not submit_button or not feedback_label or not timer:
		print("❌ ERROR: Missing UI nodes in BattleScreen!")
		return
	
	# 2) Initialize
	current_lives = total_lives
	time_left = time_limit

	# 3) Pick 3 random challenges from all_challenges
	_pick_random_challenges()

	# 4) Set up the first challenge
	_show_current_challenge()

	# 5) Configure Timer
	timer.wait_time = time_limit
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()

	# 6) Connect the submit button
	submit_button.pressed.connect(_on_SubmitButton_pressed)

	feedback_label.text = "Lives: %d" % current_lives
	print("✅ BattleScreen ready with 3 random challenges. Time limit: %s seconds." % time_limit)

func _pick_random_challenges():
	# Copy the main array so we don't modify the original
	var copy_array = all_challenges.duplicate()
	copy_array.shuffle()  # randomize order

	# Take the first 3 from the shuffled array
	selected_challenges = copy_array.slice(0, 3)

func _show_current_challenge():
	var challenge_dict = selected_challenges[current_challenge_index]
	var text = challenge_dict["challenge_text"]
	
	# Clear the TextEdit and set challenge text
	text_edit.text = text
	# Alternatively, you can show the text in a label and use TextEdit for the solution.
	# But let's assume we show the challenge in Label and user types solution in TextEdit:
	challenge_label.text = "Challenge %d/3:\n\n%s" % [current_challenge_index + 1, text]
	text_edit.text = ""  # blank for user input
	feedback_label.text = "Lives: %d" % current_lives

func _on_SubmitButton_pressed():
	var player_solution = text_edit.text
	_check_solution(player_solution)

func _check_solution(solution: String):
	var correct_sol = selected_challenges[current_challenge_index]["correct_solution"]
	
	# Compare the user's input (trim whitespace) to the correct solution
	if solution.strip_edges() == correct_sol.strip_edges():
		# If correct, move to next challenge
		current_challenge_index += 1
		if current_challenge_index >= selected_challenges.size():
			# All 3 solved => success
			success_battle()
		else:
			_show_current_challenge()
	else:
		# Decrement lives
		current_lives -= 1
		feedback_label.text = "❌ Wrong! Lives left: %d" % current_lives
		if current_lives <= 0:
			fail_battle()

func _on_Timer_timeout():
	# Time is up => fail
	fail_battle()

func success_battle():
	print("✅ Player solved all 3 challenges!")
	emit_signal("battle_won")
	queue_free()

func fail_battle():
	print("❌ Player failed (out of time or lives)!")
	emit_signal("battle_lost")
	queue_free()
