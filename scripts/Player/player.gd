class_name Player
extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var speed : 	int = 400
@export var jumpforce : int = 400
@export var gravity : 	int = 981

func _physics_process(delta: float) -> void:
## Determine the player's current facing state and flips the sprite accordingly.
	var horizontal_direction = Input.get_axis("left","right")
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
## Player movement script + Updating the animations every frame.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	update_animations(horizontal_direction)
	
## Player gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
# Player jump script.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y -= jumpforce
		
# Make the character move normally.
	move_and_slide()
	
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
