extends Area2D

func _on_body_entered(CharacterBody2D) -> void:
	if McpGlobal.meat_score >= 10:
		McpGlobal.victory_score += 1
		print('You Win!')
		McpGlobal.off = 0
	else:
		print("That is a mediocre Offering")
		McpGlobal.off = 1


func _on_body_exited(CharacterBody2D) -> void:
		print("Get more meat")
		McpGlobal.off = 0
