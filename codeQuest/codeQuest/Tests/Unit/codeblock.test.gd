extends GutTest

var code_block

func before_each():
	code_block = preload("res://Scenes/CodeBlock.tscn").instantiate()
	add_child(code_block)

func after_each():
	code_block.queue_free()
	await get_tree().process_frame

func test_initialization():
	assert_not_null(code_block.text, "CodeBlock should have an initialized text property")
	assert_eq(code_block.is_draggable, true, "CodeBlock should be draggable by default")
	assert_not_null(code_block.correct_answer, "CodeBlock should have a correct answer set in place")

func test_save_and_load_code():
	code_block.text = "print('Hello, CodeQuest!')"
	code_block.save_code()
	code_block.text = ""
	code_block._ready()
	assert_eq(code_block.text, "print('Hello, CodeQuest!')", "CodeBlock should reload saved text correctly.")
