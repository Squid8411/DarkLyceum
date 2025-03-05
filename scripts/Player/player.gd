class_name Player
extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var speed : 	int = 400
@export var jumpforce : int = 400
@export var gravity : 	int = 981
@export var attacking : bool = false

func _physics_process(delta: float) -> void:
## Determine the player's current facing state and flips the sprite accordingly.
	var horizontal_direction = Input.get_axis("left","right")
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
## Player movement script + Updating the animations every frame.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
## Player gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
## Attack function for the player.
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack()
		
## Re-focus on horizontal/vertical movement if the player is no longer attacking
	if not attacking:
		update_animations(horizontal_direction)
		
## Player jump script.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y -= jumpforce
		
## Make the character capable of movement.
	move_and_slide()
	
## Attack function.
func attack():
	attacking = true
	speed = 0
	ap.play("attack")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		attacking = false
		speed = 400
		
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
