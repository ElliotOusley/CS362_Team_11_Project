extends Node2D

var battle_instance  # Store reference to BattleScreen

func start_battle():
	print("Battle started!")

	# Load and add the battle UI
	var battle_scene = preload("res://BattleScreen.tscn")  # Update path if needed
	battle_instance = battle_scene.instantiate()
	add_child(battle_instance)

	# Connect signals properly
	battle_instance.battle_won.connect(_on_battle_won)
	battle_instance.battle_lost.connect(_on_battle_lost)

	# Pause everything EXCEPT the UI
	get_tree().paused = true
	battle_instance.process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure BattleScreen remains interactive

func _on_battle_won() -> void:
	print("Battle won! Removing Witch.")

	# Unpause the game
	get_tree().paused = false

	# Remove the Witch from the scene
	var witch = get_node_or_null("Witch")
	if witch:
		witch.queue_free()

	# Remove the battle UI
	if battle_instance:
		battle_instance.queue_free()
		battle_instance = null  # Clear reference

	print("Witch defeated!")

func _on_battle_lost() -> void:
	print("Battle lost! Witch remains.")

	# Unpause the game
	get_tree().paused = false

	# Remove only the battle UI, but keep the Witch
	if battle_instance:
		battle_instance.queue_free()
		battle_instance = null

	print("Player failed the challenge.")
