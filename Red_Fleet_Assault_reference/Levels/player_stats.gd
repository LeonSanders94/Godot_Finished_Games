extends TextEdit


func _process(delta: float) -> void:
	self.text = str('Health:', Player.Player_Stats.health,"\n",
'Armor:', Player.Player_Stats.armor,"\n",
'Shield:', Player.Player_Stats.shield,"\n",
'Speed:', Player.Player_Stats.speed,"\n",
'Damage:', Player.Player_Stats.damage,"\n",
'Fire Rate:', Player.Player_Stats.fire_rate,"\n",
'RoboMechanic:', Player.Player_Stats.robomechanic,"\n",
'Maneuvering:', Player.Player_Stats.maneuvering,"\n",
'Robo AI Integrations:', Player.Player_Stats.robo_ai_integrations,"\n",
'Life Steal:', Player.Player_Stats.life_steal,"\n",
'Repair Kits:', Player.Player_Stats.repair_kits, "\n",
"Cash:", Player.money )
