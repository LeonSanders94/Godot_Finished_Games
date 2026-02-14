extends AnimatedSprite2D

@export var carrier_bolt = preload("res://Items/Bullets_explosions/basic_bolt_r_0.tscn")
@onready var bottom_l_gun: AnimatedSprite2D = $"."

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	shoot()
	
func cooldown():
	await get_tree().create_timer(0.5).timeout
	bottom_l_gun.frame = randi() % 2
	shoot()


func shoot():
	var fb = carrier_bolt.instantiate()
	await get_tree().create_timer(1.5).timeout
	if bottom_l_gun.frame == 0:
		get_tree().root.add_child(fb)
		fb.transform = $top_shot.global_transform
		cooldown()
	if bottom_l_gun.frame == 1:
		get_tree().root.add_child(fb)
		fb.transform = $middle_shot.global_transform
		cooldown()
	if bottom_l_gun.frame == 2:
		get_tree().root.add_child(fb)
		fb.transform = $bottom_shot.global_transform
		cooldown()
