extends GutTest

var code_block

func before_each():
    code_block = preload("res://Scenes/CodeBlock.tscn").instantiate()
    add_child(code_block)

func after_each():
    if is_instance_valid(code_block):
        code_block.queue_free()
    await get_tree().process_frame

func test_initialization():
    assert_not_null(code_block, "CodeBlock instance should not be null")
    assert(code_block is Button, "CodeBlock should be a Button")

    assert(code_block.has_method("save_code"), "CodeBlock should have a save_code method")
    assert(code_block.has_method("_ready"), "CodeBlock should have a _ready method")

    if code_block.has_method("get_correct_answer"):
        assert_not_null(code_block.correct_answer, "CodeBlock should have a correct answer set")
    else:
        push_warning("CodeBlock does not have a correct answer or method to get it")

func test_save_and_load_code():
    code_block.text = "print('Hello, CodeQuest!')"
    
    if code_block.has_method("save_code"):
        code_block.save_code()
        code_block.text = ""
        code_block._ready()  # Simulate reloading
        assert_eq(code_block.text, "print('Hello, CodeQuest!')", "CodeBlock should reload saved text correctly.")
    else:
        fail_test("CodeBlock does not have a save_code method")
