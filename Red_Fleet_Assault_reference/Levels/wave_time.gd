extends Label


func _process(delta: float) -> void:
	var time_left = %Wave_Timer.get_time_left()
	self.text = "%.2f" % time_left
