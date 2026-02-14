extends AnimatedSprite2D

@onready var sqwelch: AudioStreamPlayer2D = $sqwelch
@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var area_2d: Area2D = $"../Area2D"


#You don't add in sounds to things you queue_free
func _on_area_2d_body_entered(CharacterBody2D) -> void:
	animated_sprite_2d.hide()
	area_2d.hide()
	#print('+1 Meat')
	McpGlobal.meat_score += 1
	sqwelch.play()
	



func _on_sqwelch_finished() -> void:
	var player_value = 0
	player_value += 1
	if player_value == 1:
		queue_free()
