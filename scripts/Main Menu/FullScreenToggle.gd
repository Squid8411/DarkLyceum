extends CheckButton

func _ready() -> void:
	match_screen()

func _process(delta: float) -> void:
	match_screen()

func match_screen():
	if DisplayServer.window_get_mode() == 3:
		button_pressed = true
	elif DisplayServer.window_get_mode() == 0:
		button_pressed = false

func _on_toggled(toggled_on: bool):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
