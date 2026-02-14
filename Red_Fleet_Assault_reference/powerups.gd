extends Node


## Paytype function used to access the two Attribute categories


#------WORK HERE, Add in stats modifications to player ----- ####
var weapons = {
	basic = {dmg = 5, speed = 0, shield = 0, color_p = 'blue', color_r = 'red'},
	royal_spear = {dmg = 5, speed = 2, shield = 1, color_p = 'blue', color_r = 'red'},
	drone_Bus = {dmg = 5, speed = -2, robo = 2, color_p = 'blue', color_r = 'red'},
}
var ship_choice = weapons.basic

func ship_chooser_choise():
	if ship_choice == weapons.royal_spear:
		Player.Player_Stats.speed = 2
		Player.Player_Stats.shield = 1
		Player.Player_Stats.armor = -1
	elif ship_choice == weapons.drone_Bus:  # ← Change to "elif"
		Player.Player_Stats.robo_ai_integrations = 2
		Player.Player_Attributes.robos = 2
		Player.Player_Stats.speed = -2
		Player.Player_Stats.fire_rate = -1
		
	Player.Player_Attributes.player_hp_total += Player.Player_Stats.health
	Player.Player_Attributes.player_current_HP = Player.Player_Attributes.player_hp_total
	Player.Player_Attributes.player_shield_max += Player.Player_Stats.shield
	Player.Player_Attributes.player_shield_current = Player.Player_Attributes.player_shield_max
	Player.Player_Attributes.robos = Player.Player_Stats.robo_ai_integrations
	# Apply speed modification
	Player.speed_mod = -Player.Player_Stats.speed  # Negative because speed_mod subtracts
	Player.Player_Attributes.player_weapon_main = ship_choice
	Player.Player_Attributes.player_weapon_dmg = ship_choice.dmg
	Player.Player_Attributes.player_weapon_color = ship_choice.color_p
##---------Debug for weapons-----------##
#if Player.is_player == true and Player.Player_Attributes.player_weapon_main == 'Basic':
	#print('Player accessed paytype!')
#print(weapons['basic']['color_p'])
#------------------------------------------------------------#
