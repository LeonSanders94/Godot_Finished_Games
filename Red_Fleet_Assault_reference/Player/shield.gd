extends AnimatedSprite2D


func _process(delta):
	if Player.Player_Attributes.player_shield_current > 0:
		show()
	else:
		hide()
