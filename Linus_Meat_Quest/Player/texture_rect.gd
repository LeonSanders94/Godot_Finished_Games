extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file('res://Player/mcp.tscn')
	McpGlobal.Linus_health += 3
	McpGlobal.meat_score = 0
	McpGlobal.game_over = false
	McpGlobal.victory_score = 0
	McpGlobal.Winner_count = 0
	McpGlobal.winner = false
	audio_stream_player.play()

func _on_quit_pressed() -> void:
	get_tree().quit()
