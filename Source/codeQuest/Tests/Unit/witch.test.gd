extends GutTest

var witch: Witch

func before_each():
    witch = Witch.new()
    add_child(witch)

func test_witch_exists():
    assert_not_null(witch, "Witch instance should exist.")
