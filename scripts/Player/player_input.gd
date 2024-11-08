class_name PlayerInput
extends Node

@export var character : PlatformerCharacter2D
@export var actions : PlayerInputActions

func _physics_process(delta: float) -> void:
	character.direction = Input.get_vector(actions.left, actions.right, actions.up, actions.down)
