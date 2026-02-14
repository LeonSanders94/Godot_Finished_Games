extends Label


func _process(delta: float) -> void:
	self.text = str("Total Score: ",GameInfo.total_score)
