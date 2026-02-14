extends Node2D

func _process(delta: float) -> void:
	if McpGlobal.game_over == true:
		SceneTree.current_scene.paused == true
