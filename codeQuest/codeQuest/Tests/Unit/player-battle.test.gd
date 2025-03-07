extends GutTest

var player
var witch

func before_each():
	player = preload("res://Scenes/Player.tscn").instantiate()
	witch = preload("res://Scenes/Witch.tscn").instantiate()
	add_child(player)
	add_child(witch)

func after_each():
	player.queue_free()
	witch.queue_free()
	await get_tree().process_frame

func test_attack_reduces_witch_health():
	witch.health = 100
	player.attack_damage = 20
	player.attack(witch)
	assert_eq(witch.health, 80, "Witch health should decrease by player's attack damage")

func test_attack_does_not_go_negative():
	witch.health = 10
	player.attack_damage = 20
	player.attack(witch)
	assert_gte(witch.health, 0, "Witch health should not go below zero")

