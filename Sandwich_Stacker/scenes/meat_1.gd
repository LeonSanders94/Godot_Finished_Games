extends Area2D

var fall_speed: float = 150.0 
var is_caught: bool = false
@onready var meat_1: Area2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.frame = randi_range(0, 14)  # Randomly picks 0-14
	var g_or_b = randi_range(0,2)
	if g_or_b == 2:
		remove_from_group("ingredients")
		add_to_group("rotten")
		$AnimatedSprite2D.modulate = Color(0,0.45,0.18,1.00)
		$AnimatedSprite2D/CPUParticles2D.show()
	else:
		pass
	
func _physics_process(delta):
	if not is_caught:
		position.y += fall_speed * delta + (GameInfo.current_score * .001)
	if is_caught:
		set_collision_layer_value(1, false)
	if GameInfo.Global_level_tracker > 1:
		fall_speed += GameInfo.Global_level_tracker * 0.25
	
