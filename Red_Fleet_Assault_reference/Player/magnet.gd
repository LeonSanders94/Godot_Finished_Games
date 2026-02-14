extends AnimatedSprite2D

func _process(delta):
	if Player.Player_Attributes.magnet == true:
		show()
	else:
		hide()

func increase_money():
	Player.money += 8 + (Player.Wave * 2)
	Player.report.Total_Money_Collected += 10 + (Player.Wave * 2)

func increase_money_tier2():
	Player.money += 23 + (Player.Wave * 2)
	Player.report.Total_Money_Collected += 23 + (Player.Wave * 2)

func _on_mag_zone_area_entered(area: Area2D) -> void:
	if area.has_method("magnitize"):
		print("hello from the mag zone!!")
		area.magnitize(area)
#I LOVE YOU TYLER JOHN BONATESTA 
