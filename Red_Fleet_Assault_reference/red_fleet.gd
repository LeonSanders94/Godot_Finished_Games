extends Node

var belongs_in_RF = true
var EOW = false

var fighter_count = 0
var bomber_count = 0

var Fleet_Attributes = {
	tier_1 = {
		dmg = 5,
		hp = 5,
		spd = randi() % 100 + 75,
		color = 'red',
		points = 2
	},
	tier_2 = {
		dmg = 25,
		hp = 15,
		spd = randi() % 75 + 50,
		color = 'red',
		points = 5
	},
	tier_3 = {
		dmg = 20,
		hp = 50,
		spd = 200,
		color = 'red',
		points = 13
	},
	tier_4= {
		dmg_1 = 10,
		dmg_2 = 15,
		hp = 100,
		spd = 200,
		color = 'red',
		points = 25
	},
	tier_5 = {
		dmg_1 = 10,
		dmg_2 = 15,
		dmg_3 = 50,
		hp = 200,
		spd = 200,
		color = 'red',
		points = 200
	},
	
}
var  Fleet_Roster = {
	fghtr_1 = Fleet_Attributes.tier_1,
	bmber_1 = Fleet_Attributes.tier_1,
	tank_2 = Fleet_Attributes.tier_2,
	Advanced_2= Fleet_Attributes.tier_2,
	cruiser_3= Fleet_Attributes.tier_3,
	capital_5= Fleet_Attributes.tier_5
}
