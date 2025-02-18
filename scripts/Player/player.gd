class_name Player
extends PlatformerCharacter2D

@export_range(0, 100, .2, "or_greater") var move_speed : float = 50.0
@export_range(0, 100, .2, "or_greater") var jump_force : float = 100.0

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
## Determine the player's current facing state and flips the sprite accordingly.
	var horizontal_direction = Input.get_axis("left","right")
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
## Sets the current velocity and gravity together with movement normalization.
	velocity.x = move_speed * direction.x
	apply_gravity(delta)
	move_and_slide()
	update_animations(horizontal_direction)
	
## Make the character jump if possible.
## Returns true if jump succeeded or false if failed.
func try_jump() -> bool:
	if is_on_floor():
		_jump()
		return true
	
	return false
## Perform a ground jump.
func _jump():
	velocity.y -= jump_force
	
## Updates animations depending on the current state.
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")
