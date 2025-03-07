extends CharacterBody2D

@export var speed: float = 100.0
@export var detection_range: float = 200.0  # Hoe dichtbij de vijand moet komen om aan te vallen
@export var attack_damage: int = 5  # Hoeveel damage de vijand doet
@export var attack_rate: float = 5.0  # Tijd tussen aanvallen
@onready var ap = $AnimationPlayer  # Aanval animatie wordt beheerd door de AnimationPlayer

var player = null  # De speler wordt hier opgeslagen als hij in range is
var can_attack = true  # Geeft aan of de vijand al dan niet mag aanvallen

func _ready():
	$AnimatedSprite2D.play("idle")  # Start in idle mode
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Als de speler in het bereik komt
	if body and body.is_in_group("player"):
		player = body

func _on_body_exited(body):
	# Als de speler uit het bereik gaat
	if body == player:
		player = null

func attack():
	# Deze functie speelt de aanval animatie af
	print("⚔️ Aanval uitgevoerd!")
	$AnimatedSprite2D.play("attack")  # Speel de aanval animatie af

	# De aanval gebeurt nadat de animatie wordt afgespeeld
	if player and player.get_global_position().distance_to(global_position) <= detection_range:
		print("💀 Speler krijgt schade!")
		player.take_damage(attack_damage)  # Roep de take_damage functie van de speler aan

func _physics_process(delta):
	if player:
		# Beweeg de vijand richting de speler
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Flip de vijand afhankelijk van de beweging
		$AnimatedSprite2D.flip_h = velocity.x < 0

		# Wanneer de vijand dichtbij genoeg komt, aanval uitvoeren
		if can_attack and global_position.distance_to(player.global_position) <= detection_range:
			attack()
			can_attack = false
			# Zet een timer om te wachten voordat de vijand weer kan aanvallen
			await get_tree().create_timer(attack_rate).timeout
			can_attack = true

		# Speel loop animatie als de vijand beweegt
		if velocity.length() > 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

	else:
		$AnimatedSprite2D.play("idle")  # Stop met bewegen als de speler niet meer in het bereik is

		# Zet de timer in gang voor de volgende aanval
		await get_tree().create_timer(attack_rate).timeout  # Gebruik await om te wachten op de timer
		can_attack = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().die()
		
func die():
	queue_free()
