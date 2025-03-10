extends Control

@onready var back_button = $Options/Button
@onready var keybinds_container = $Options/KeybindsContainer

var awaiting_keybind: String = ""

# Default player controls
var keybinds = {
	"move_left": KEY_A,
	"move_right": KEY_D,
	"jump": KEY_SPACE,
	"attack": KEY_F
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_button_pressed)
	_create_options_menu()
	_create_keybind_menu()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _create_options_menu() -> void:
	var options = $Options
	
	# Remove placeholder label
	var label = options.get_node_or_null("Label")
	if label:
		label.queue_free()

	# Volume Controls
	var master_volume = _create_slider("Master Volume", "Master")
	var sfx_volume = _create_slider("SFX Volume", "SFX")
	var music_volume = _create_slider("Music Volume", "Music")

	options.add_child(master_volume)
	options.add_child(sfx_volume)
	options.add_child(music_volume)

	# Fullscreen Toggle
	var fullscreen_toggle = CheckButton.new()
	fullscreen_toggle.text = "Fullscreen Mode"
	fullscreen_toggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	options.add_child(fullscreen_toggle)

func _create_slider(label_text: String, bus_name: String) -> HBoxContainer:
	var container = HBoxContainer.new()
	var label = Label.new()
	label.text = label_text

	var slider = HSlider.new()
	slider.min_value = -30
	slider.max_value = 0
	slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(func(value): _on_volume_changed(value, bus_name))

	container.add_child(label)
	container.add_child(slider)
	return container

func _on_volume_changed(value: float, bus_name: String) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), value)

func _on_fullscreen_toggled(pressed: bool) -> void:
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

### Keybinding System ###
func _create_keybind_menu() -> void:
	for action in keybinds.keys():
		var container = HBoxContainer.new()
		var label = Label.new()
		label.text = action.capitalize().replace("_", " ") + ":"

		var button = Button.new()
		button.text = OS.get_keycode_string(keybinds[action])
		button.pressed.connect(func(): _on_keybind_pressed(action, button))

		container.add_child(label)
		container.add_child(button)
		keybinds_container.add_child(container)

func _on_keybind_pressed(action: String, button: Button) -> void:
	awaiting_keybind = action
	button.text = "Press a key..."
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if awaiting_keybind != "" and event is InputEventKey and event.pressed:
		keybinds[awaiting_keybind] = event.keycode
		_update_keybinds_ui()
		awaiting_keybind = ""
		set_process_input(false)

func _update_keybinds_ui() -> void:
	for child in keybinds_container.get_children():
		var label = child.get_child(0)
		var button = child.get_child(1)
		var action = label.text.to_lower().replace(" ", "_").rstrip(":")
		button.text = OS.get_keycode_string(keybinds[action])
