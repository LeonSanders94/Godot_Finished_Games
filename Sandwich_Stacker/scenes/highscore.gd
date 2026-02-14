extends Label



func _process(delta: float) -> void:
	self.text = str("HIGHSCORE: ",GameInfo.highscore)
