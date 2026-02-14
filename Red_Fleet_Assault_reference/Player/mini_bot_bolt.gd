extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var damage: float
var speed = 700
var color = 'blue'
var dmg = Player.Player_Attributes.player_weapon_dmg * Player.Player_Attributes.robo_dmg

# Timer replacement (ONLY change)
var lifetime_timer: float = 0.0

func _ready():
	dmg = Player.Player_Attributes.player_weapon_dmg * Player.Player_Attributes.robo_dmg
	
	if color == 'blue':
		animated_sprite_2d.play('bolt')

func _physics_process(delta):
	# Original movement (unchanged)
	position -= transform.y * speed * delta
	
	# Timer replacement (ONLY change)
	lifetime_timer += delta
	if lifetime_timer >= 2.0 or RedFleet.EOW == true:
		queue_free()

# Removed problematic _process function entirely

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("take_damage"):
		Player.Player_Attributes.player_current_HP += Player.Player_Attributes.leech
		damage = dmg
		body.take_damage(damage)
		queue_free()
