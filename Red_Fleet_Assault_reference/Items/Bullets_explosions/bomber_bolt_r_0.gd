extends Area2D

@onready var basic_an = $Bomber_bolt

@export var damage: float
@export var speed: float = 150.0
@export var color: String = 'red'

# Constants
const MAX_LIFETIME = 10.0
const BASE_DAMAGE = 10.0

# Runtime variables
var dmg: float
var lifetime_timer: float = 0.0

func _ready():
	# Calculate damage with wave scaling
	dmg = BASE_DAMAGE + (Player.Wave * 0.5)
	
	# Set animation based on color
	if color == 'red':
		basic_an.play('red_ball')
	
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	# Move bullet (bomber bullets go upward like player bullets)
	position -= transform.y * speed * delta
	
	# Update lifetime
	lifetime_timer += delta
	
	# Check if bullet should be destroyed
	if lifetime_timer >= MAX_LIFETIME:
		queue_free()
		return
	
	# Check for end of wave
	if RedFleet.EOW == true:
		queue_free()
		return
	
	# Check if bullet is off-screen (going upward)
	if position.y < -100:  # Off top of screen
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Only damage the player
	if not Player.is_player or not body.has_method("take_damage"):
		return
	
	print('Bomber bullet hit player!')
	damage = dmg
	body.take_damage(damage)
	queue_free()
