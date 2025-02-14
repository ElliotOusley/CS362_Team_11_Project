extends CanvasLayer

signal battle_won
signal battle_lost

var all_challenges := [
	{"challenge_text": "# Fix this Python print statement:\nprint(\"Hello World) # missing quote", "correct_solution": "print(\"Hello World\")"},
	{"challenge_text": "# Fix the variable assignment in GDScript:\nvar number = 10\nvar total = number + \"5\" # Incorrect", "correct_solution": "var number = 10\nvar total = number + 5"},
	{"challenge_text": "# Fix the JavaScript console.log statement:\nconsole.log(\"Hello World);", "correct_solution": "console.log(\"Hello World\");"},
	{"challenge_text": "# Fix the C# main method signature:\npublic static void main(String[] args){ Console.WriteLine(\"Hello\"); }", "correct_solution": "public static void Main(string[] args){ Console.WriteLine(\"Hello\"); }"},
	{"challenge_text": "# Fix the HTML element:\n<a href=\"www.example.com>Click me!</a>", "correct_solution": "<a href=\"www.example.com\">Click me!</a>"},
	{"challenge_text": "# Fix the JSON structure:\n{ \"name\": \"Alice\", \"age\": 30, \"city\": \"Wonderland\"", "correct_solution": "{ \"name\": \"Alice\", \"age\": 30, \"city\": \"Wonderland\" }"},
	{"challenge_text": "# Fix the Python indent error:\ndef greet():\nprint(\"Hello\")", "correct_solution": "def greet():\n\tprint(\"Hello\")"}
]

@export var time_limit: float = 60.0  
@export var total_lives: int = 3     

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
	if !_validate_ui_nodes():
		return

	current_lives = total_lives
	time_left = time_limit

	_pick_random_challenges()
	_show_current_challenge()

	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_tick)
	timer.start()
	_update_timer_display()

	submit_button.pressed.connect(_on_submit_pressed)
	feedback_label.text = "Lives: %d" % current_lives

func _validate_ui_nodes() -> bool:
	if not challenge_label or not text_edit or not submit_button or not feedback_label or not timer:
		print("❌ ERROR: Missing UI nodes in BattleScreen!")
		return false
	return true

func _pick_random_challenges():
	var shuffled = all_challenges.duplicate()
	shuffled.shuffle()
	selected_challenges = shuffled.slice(0, 3)

func _show_current_challenge():
	var challenge_dict = selected_challenges[current_challenge_index]
	challenge_label.text = "Challenge %d/3:\n\n%s" % [current_challenge_index + 1, challenge_dict["challenge_text"]]
	text_edit.text = ""
	feedback_label.text = "Lives: %d" % current_lives

func _on_submit_pressed():
	_check_solution(text_edit.text)

func _check_solution(solution: String):
	var correct_solution = selected_challenges[current_challenge_index]["correct_solution"]
	if solution.strip_edges().to_lower() == correct_solution.strip_edges().to_lower():
		current_challenge_index += 1
		if current_challenge_index >= selected_challenges.size():
			_success_battle()
		else:
			_show_current_challenge()
	else:
		_penalize_attempt()

func _penalize_attempt():
	current_lives -= 1
	feedback_label.text = "❌ Incorrect! Lives left: %d" % current_lives
	if current_lives <= 0:
		_fail_battle()

func _on_timer_tick():
	time_left -= 1
	_update_timer_display()
	if time_left <= 0:
		_fail_battle()

func _update_timer_display():
	timer_label.text = "⏳ Time Left: %d sec" % time_left

func _success_battle():
	print("✅ Player solved all 3 challenges!")
	emit
