extends CheckButton

func _ready():
	if DisplayServer.window_get_mode() == 3:
		button_pressed = true

func _on_toggled(toggled_on: bool):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
