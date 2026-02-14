extends Label



func _process(delta: float) -> void:
	self.text = str("Current Sandwich: ",GameInfo.current_score)
