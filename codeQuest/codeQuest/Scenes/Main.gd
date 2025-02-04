extends Node2D

var battle_instance  # Store reference to BattleScreen

func start_battle():
	print("Battle started! Trying to instantiate BattleScreen...")

	# Load and add the battle UI
	var battle_scene = preload("res://BattleScreen.tscn")  # Ensure the path is correct
	battle_instance = battle_scene.instantiate()

	if battle_instance == null:
		print("ERROR: Failed to instantiate BattleScreen!")
		return
	
	add_child(battle_instance)
	print("BattleScreen added to the scene successfully!")

	# Connect signals properly
	if battle_instance.has_signal("battle_won"):
		battle_instance.battle_won.connect(_on_battle_won)
	else:
		print("ERROR: BattleScreen is missing 'battle_won' signal!")

	if battle_instance.has_signal("battle_lost"):
		battle_instance.battle_lost.connect(_on_battle_lost)
	else:
		print("ERROR: BattleScreen is missing 'battle_lost' signal!")

	# Ensure the BattleScreen processes input even if the game is paused
	battle_instance.process_mode = Node.PROCESS_MODE_ALWAYS  

	# Pause everything EXCEPT the BattleScreen
	get_tree().paused = true
	print("Game paused, BattleScreen should still work.")

func _on_battle_won() -> void:
	print("Battle won! Removing Witch.")

	# Unpause the game
	get_tree().paused = false

	# Remove the Witch from the scene
	var witch = get_node_or_null("Witch")
	if witch:
		witch.queue_free()
		print("Witch removed.")

	# Remove the battle UI
	if battle_instance:
		battle_instance.queue_free()
		battle_instance = null
		print("BattleScreen removed.")

func _on_battle_lost() -> void:
	print("Battle lost! Witch remains.")

	# Unpause the game
	get_tree().paused = false

	# Remove only the battle UI, but keep the Witch
	if battle_instance:
		battle_instance.queue_free()
		battle_instance = null
		print("BattleScreen removed, Witch stays.")
