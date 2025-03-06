extends GutTest

var player

func before_each():
	player = preload("res://Scenes/Player.tscn").instantiate()
	add_child(player)

func after_each():
	player.queue_free()
	await get_tree().process_frame

func test_initialization():
	assert_not_null(player.actionable_finder, "ActionableFinder should be initialized.")
	assert_not_null(player.footstep_audio, "FootstepAudio should be initialized.")
	assert_not_null(player.UI, "UI should be initialized.")
	assert_not_null(player.inventory_HUD, "InventoryHUD should be initialized.")
	assert_eq(player.speed, 50, "Player speed should be initialized to 50.")

func test_save_and_load_position():
	player.position = Vector2(100, 200)
	player.save_position()
	player.position = Vector2.ZERO
	player._ready()
	assert_eq(player.position, Vector2(100, 200), "Player should reload saved position correctly.")
