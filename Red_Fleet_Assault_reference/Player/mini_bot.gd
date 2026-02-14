extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $mini_bot  
@onready var shoot_marker: Marker2D = $Marker2D  
@export var bot_bolt_scene: PackedScene
var bot_index: int = 0
var cooldown_timer: float = 0.0
var shoot_cooldown: float = 0.2

func _ready():
	if sprite:
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")

func _physics_process(delta: float):
	if cooldown_timer > 0:
		cooldown_timer -= delta

func shoot_north():
	if cooldown_timer > 0:
		return
	
	if not bot_bolt_scene:
		push_warning("Bot bolt scene not assigned!")
		return
	
	var bullet = bot_bolt_scene.instantiate()
	get_tree().current_scene.add_child(bullet)  # Original method
	
	if shoot_marker:
		bullet.global_position = shoot_marker.global_position
	else:
		bullet.global_position = global_position
	
	cooldown_timer = shoot_cooldown
	play_shoot_effect()

func play_shoot_effect():
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color.WHITE * 1.5, 0.05)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.05)

func set_bot_properties(index: int):
	bot_index = index
	if sprite:
		match index % 3:
			0:
				sprite.modulate = Color.WHITE
			1:
				sprite.modulate = Color.CYAN
			2:
				sprite.modulate = Color.YELLOW
