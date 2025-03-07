class_name Player
extends CharacterBody2D

@onready var ap = $AnimationPlayer	# Reference to node for playing animations
@onready var sprite = $Sprite2D		# Reference to node for the player sprite
@onready var health_bar = $HP		# Reference to node for HP bar

@export var max_health: int = 200 # Maximum player HP
@export var speed : 	int = 400 # Player speed
@export var jumpforce : int = 400 # Player jump height
@export var gravity : 	int = 981 # Applied gravity in the environment
@export var attacking : bool = false

var current_health: int

func _ready():
		current_health = max_health
		
func _physics_process(delta: float) -> void:
## Determine the player's current facing state and flips the sprite accordingly
	var horizontal_direction = Input.get_axis("left","right")
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	if horizontal_direction == -1:
		$Area2D.scale.x = abs($Area2D.scale.x) * -1
	else:
		$Area2D.scale.x = abs($Area2D.scale.x)
	
## Player movement script + Updating the animations every frame
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
## Player gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
## Attack function for the player
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack()
		
## Kill the player if the equals key is pressed
	if Input.is_action_just_pressed("die"):
		die()
		
## Re-focus on horizontal/vertical movement if the player is no longer attacking
	if not attacking:
		update_animations(horizontal_direction)
		
## Player jump script
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y -= jumpforce
		
## Make the character capable of movement
	move_and_slide()
	
## Attack function
func attack():
	var overlapping_objects = $Area2D.get_overlapping_areas()
	
	for area in overlapping_objects:
		if area.get_parent().is_in_group("enemy"):
			area.get_parent().die()
	
	attacking = true
	speed = 0
	ap.play("attack")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		attacking = false
		speed = 400
		
## Updates animations depending on the current state
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
			
# Updates the health bar
func update_health_bar():
	var percentage = float(current_health) / max_health  # HP in percentage
	var new_width = percentage * health_bar.size.x  # Calculate new width
	health_bar.set_size(Vector2(new_width, health_bar.size.y))  # Adjust width
	
# Functie om schade te krijgen
func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)  # Zorgt dat HP niet onder 0 gaat
	update_health_bar()
	
	# Controleer of de speler dood is
	if current_health == 0:
		die()
	
# Speler sterft
func die():
	ap.play("die")  # Speel sterf animatie af
	queue_free()  # Speler verdwijnt
