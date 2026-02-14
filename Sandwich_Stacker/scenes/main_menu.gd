extends Control


func _process(delta: float) -> void:
	if Input.is_action_just_released("clear_HS"):
		GameInfo.highscore = 1000


func _on_start_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/debug_test.tscn")


func _on_exit_button_up() -> void:
	GameInfo.save_high_score()
	get_tree().quit()
