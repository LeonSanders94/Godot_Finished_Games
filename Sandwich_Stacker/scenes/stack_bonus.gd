extends Label


func _process(delta: float) -> void:
	self.text = str("Stack Bonus: ",$"../../..".stack_size_getter)
