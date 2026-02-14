extends Control


func _on_shop_ship_area_body_entered(body: Node2D) -> void:
	show()


func _on_next_round_pressed() -> void:
	get_tree().change_scene_to_file(("res://Enemies/ship_select.tscn"))
