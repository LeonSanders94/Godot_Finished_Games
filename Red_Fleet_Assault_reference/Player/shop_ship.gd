extends Node2D

var move_down:bool


func _process(delta):
	if move_down == true:
		$"..".progress_ratio += delta  * 0.25
	if move_down == false:
		$"..".progress_ratio = $"..".progress_ratio + delta * -0.75

func _on_shop_ship_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Playergroup'):
		%shopv2.show()


func _on_wave_timer_timeout() -> void:
	move_down = true
	await get_tree().create_timer(12.0).timeout
	move_down = false
	await get_tree().create_timer(5.0).timeout
	$"..".progress_ratio = 0
