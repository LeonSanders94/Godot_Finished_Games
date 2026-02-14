extends Label


func _process(delta: float) -> void:
	self.text = str('Bonus :',Player.money)
