extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = str('Score :',Player.Player_Attributes.player_score)
