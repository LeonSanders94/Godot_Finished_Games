extends Label

func _process(delta: float) -> void:
	self.text = str(
'Total Kills:', Player.report.Total_kills,"\n",
'Fighter Kills:', Player.report.Fighter_kills,"\n",
'Bomber Kills:', Player.report.Bomber_kills,"\n",
'Carrier Kills:', Player.report.Carrier_kills,"\n",
'Total Hits:', Player.report.Total_hits,"\n",
'Accuracy:',Player.report.Accuracy,"\n",
'Total Shots:', Player.report.Total_shots,"\n",
'Damage Taken:', Player.report.Damage_taken,"\n",
'Damage Dealt:', Player.report.Damage_dealt,"\n",
'Total Money Collected:', Player.report.Total_Money_Collected,"\n",)
