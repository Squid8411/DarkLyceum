extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == 3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		elif DisplayServer.window_get_mode() == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
