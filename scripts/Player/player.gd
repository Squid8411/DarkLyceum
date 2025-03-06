extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar/Foreground  # De rode PNG-balk
@onready var health_bar_bg = $HealthBar/Background  # De grijze PNG-balk

@export var speed: int = 400
@export var jumpforce: int = 400
@export var gravity: int = 981
@export var max_health: int = 200  # Maximale HP

var current_health: int

func _ready():
	current_health = max_health
	update_health_bar()

func _physics_process(delta: float) -> void:
	## Speler beweging & animatie
	var horizontal_direction = Input.get_axis("left","right")
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)

	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	update_animations(horizontal_direction)

	## Zwaartekracht
	if not is_on_floor():
		velocity.y += gravity * delta

	## Springen
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y -= jumpforce

	move_and_slide()

# Updates animaties afhankelijk van de staat
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

# Functie om schade te krijgen
func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)  # Zorgt dat HP niet onder 0 gaat
	update_health_bar()

	# Controleer of de speler dood is
	if current_health == 0:
		die()

# Update de gezondheidsbalk
func update_health_bar():
	var percentage = float(current_health) / max_health  # HP in percentage
	var new_width = percentage * health_bar_bg.size.x  # Bereken nieuwe breedte
	health_bar.set_size(Vector2(new_width, health_bar.size.y))  # Pas breedte aan

# Speler sterft
func die():
	ap.play("die")  # Speel sterf animatie af
	queue_free()  # Speler verdwijnt
