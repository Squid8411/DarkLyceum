class_name Player
extends PlatformerCharacter2D

@export_range(0, 100, .2, "or_greater") var move_speed : float = 50.0
@export var actions : PlayerInputActions

func _physics_process(delta: float) -> void:
	direction = Input.get_vector(actions.left, actions.right, actions.up, actions.down)
	
	velocity.x = move_speed * direction.x
	
	move_and_slide()
