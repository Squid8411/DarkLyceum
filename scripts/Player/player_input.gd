class_name PlayerInput
extends Node

@export var player : Player
@export var actions : PlayerInputActions

func _process(_delta: float) -> void:
	player.direction = Input.get_vector(actions.left, actions.right, actions.up, actions.down)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(actions.jump):
		player.try_jump()
