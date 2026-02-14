extends Label




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = str("DROPS LEFT: ",$"../../..".drop_limit)
