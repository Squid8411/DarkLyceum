class_name Player
extends PlatformerCharacter2D

@export_range(0, 100, .2, "or_greater") var move_speed : float = 50.0
@export_range(0, 100, .2, "or_greater") var jump_force : float = 100.0

func _physics_process(delta: float) -> void:
	velocity.x = move_speed * direction.x
	apply_gravity(delta)
	move_and_slide()
	
## Make the character jump if possible.
##
## Returns true if jump succeeded or false if failed.
func try_jump() -> bool:
	if is_on_floor():
		_jump()
		return true
	
	return false
## Perform a ground jump.
func _jump():
	velocity.y -= jump_force
