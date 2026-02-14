extends Area2D

@onready var basic_an = $basic_red
var speed = 225
var color = 'red'
var dmg = 5
@export var damage: float


var lifetime_timer: float = 0.0

func _ready():
	dmg = 5 + (Player.Wave * 0.5)

func _physics_process(delta):
	if Debug.debug_enabled:
		Debug.start_timer("player_bullet_physics")
	if RedFleet.EOW == true:
		queue_free()
	position -= transform.y * speed * delta
	

	lifetime_timer += delta
	if lifetime_timer >= 3.75 or RedFleet.EOW == true:
		queue_free()
	if Debug.debug_enabled:
		Debug.end_timer("player_bullet_physics")


func _on_body_entered(body: Node2D) -> void:
	if Player.is_player == true and body.has_method("take_damage"):
		print('Gotcha!')
		damage = dmg + (Player.Wave * 0.5)
		body.take_damage(damage)
	queue_free()
