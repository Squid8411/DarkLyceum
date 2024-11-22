class_name PlatformerCharacter2D
extends CharacterBody2D

signal direction_changed(direction : Vector2)

var direction : Vector2 :
	set(value):
		if direction == value:
			return
		
		direction = value
		direction_changed.emit(direction)


func apply_gravity(delta : float):
	var gravity = get_gravity()
	velocity.x += gravity.x * delta
	velocity.y += gravity.y * delta
