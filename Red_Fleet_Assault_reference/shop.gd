extends Node

var empty_slot = {"Name" = 'none', icon = preload("res://Items/icons/Icon_background.png"), rarity = 'none'}

var items_com = {
	0:{
		"Name" = "Advanced Blaster",
		rarity = "common",
		pos_1 = Player.Player_Stats.damage + 1,
		pos_2 = Player.Player_Stats.fire_rate + 1,
		icon = preload("res://Items/icons/adv_blaster_icon.png")
	},
	1:{
		"Name" = "Targeting Computer",
		rarity = "common",
		pos_1 = Player.Player_Stats.fire_rate + 1,
		icon = preload("res://Items/icons/Targeting_Computer_icon.png")

	},
	2:{
		"Name" = "Extra Batteries",
		rarity = "common",
		pos_1 = Player.Player_Stats.shield + 1,
		icon = preload("res://Items/icons/Extra_Batteries_icon.png")
	},
	3:{
		"Name" = "Spring Cleaning",
		rarity = "common",
		pos_1 = Player.Player_Stats.repair_kits + 1,
		icon = preload("res://Items/icons/Spring_cleaning_icon.png")
	},
	4:{
		"Name" = "A Few Sticks Of RAM",
		rarity = "common",
		pos_1 = Player.Player_Stats.robo_ai_integrations + 1,
		icon = preload("res://Items/icons/A_Few_Sticks_Of_RAM.png")
	},
	5:{
		"Name" = "Mini Bot",
		rarity = "common",
		pos_1 = "aimbot_1",
		icon = preload("res://Items/icons/mini_bot_icon.png")
	},
	6:{
		"Name" = "Heal Bot",
		rarity = "common",
		pos_1 = Player.Player_Stats.robomechanic + 1,
		icon = preload("res://Items/icons/heal_bot_icon.png")
	},
	7:{
		"Name" = "Heavy Blaster",
		rarity = "common",
		pos_1 = Player.Player_Stats.damage + 2,
		neg_1 = Player.Player_Stats.fire_rate - 1,
		icon = preload("res://Items/icons/heavy_blaster_icon.png")
	},
	8:{
		"Name" = "Turbo Boosters",
		rarity = "common",
		pos_1 = Player.Player_Stats.speed + 1,
		neg_1 = Player.Player_Stats.armor - 1,
		icon = preload("res://Items/icons/turbo_boosters_icon.png")
	},
	9:{
		"Name" = "Nanomachines",
		rarity = "common",
		pos_1 = Player.Player_Stats.life_steal + 1,
		neg_1 = Player.Player_Stats.fire_rate - 1,
		icon = preload("res://Items/icons/Nanomachines.png")
	},
	10:{
		"Name" = "Red Baron Kit",
		rarity = "common",
		pos_1 = Player.Player_Stats.maneuvering + 1,
		icon = preload("res://Items/icons/Red_Baron_kit_icon.png")
	},
	11:{
		"Name" = "Shield Bot",
		rarity = "common",
		pos_1 = Player.Player_Stats.shield + 1,
		icon = preload("res://Items/icons/shield_bot_icon.png")
	},
	12:{
		"Name" = "Health +",
		rarity = "common",
		pos_1 = Player.Player_Stats.health + 1,
		icon = preload("res://Items/icons/health_plus_icon.png")
	},
	13:{
		"Name" = "Reinforced Hull",
		rarity = "common",
		pos_1 = Player.Player_Stats.health + 1,
		icon = preload("res://Items/icons/reinforced_hull_icon.png")
	},
	14:{
	Name = "Recycled Metal",
	rarity = "common",
	pos_1 = Player.Player_Stats.armor + 1,
	icon =  preload("res://Items/icons/recycled_metal_icon.png")
	},
	15:{
	"Name" = "Extra Stuffing",
	rarity = "common",
	pos_1 = Player.Player_Stats.armor + 1,
	icon = preload("res://Items/icons/extra_stuffing_icon.png")
	},
	16:{
	"Name" = "Deflector Plates",
	rarity = "common",
	pos_1 = Player.Player_Stats.armor + 2,
	icon = preload("res://Items/icons/deflector_plates_icon.png")
	},
	17: {
	"Name" = "Overclock Module",
	rarity = "common",
	pos_1 = Player.Player_Stats.fire_rate + 1,
	pos_2 = Player.Player_Stats.damage + 2,
	icon = preload("res://Items/icons/overclock_module_icon.png")
	},
	18: {
	"Name" = "Vampire Plasma",
	rarity = "common",
	pos_1 = Player.Player_Stats.life_steal + 1,
	icon = preload("res://Items/icons/vampire_plasma_icon.png")
	},
	19: {
	"Name" = "Mr. Fix It",
	rarity = "common",
	pos_1 = Player.Player_Stats.robomechanic + 1,
	icon = preload("res://Items/icons/mr_fix_it_icon.png")
	},
	20: {
	"Name" = "Lightweight Frame",
	rarity = "common",
	pos_1 = Player.Player_Stats.speed + 1,
	neg_1 = Player.Player_Stats.armor - 1,
	icon = preload("res://Items/icons/lightweight_frame_icon.png")
	},

	21: {
	"Name" = "Space Dust Extract",
	rarity = "common",
	pos_1 = Player.Player_Stats.speed + 2,
	neg_1 = Player.Player_Stats.maneuvering - 1,
	icon = preload("res://Items/icons/space_dust_icon.png")
},

	22: {
	"Name" = "Power Capacitor",
	rarity = "common",
	pos_1= Player.Player_Stats.damage + 1,
	neg_1 = Player.Player_Stats.shield - 1,
	icon = preload("res://Items/icons/power_capacitor_icon.png")
},

	23: {
	"Name" = "Rapid Loader",
	rarity = "common",
	pos_1 = Player.Player_Stats.fire_rate + 1,
	neg_1 = Player.Player_Stats.damage - 1,
	icon = preload("res://Items/icons/rapid_loader_icon.png")
},

	24: {
	"Name"= "Precision Targeting",
	rarity = "common",
	pos_1 = Player.Player_Stats.damage + 1,
	neg_1 = Player.Player_Stats.fire_rate - 1,
	icon = preload("res://Items/icons/precision_targeting_icon.png")
},

	25: {
	"Name" ="Glass Cannon",
	rarity = "common",
	pos_1 = Player.Player_Stats.damage + 1,
	neg_1 = Player.Player_Stats.fire_rate - 1,
	icon = preload("res://Items/icons/glass_cannon_icon.png")
},

	26: {
	"Name" = "Overcharge Capacitor",
	rarity = "common",
	pos_1 = Player.Player_Stats.damage + 2,
	pos_2 = Player.Player_Stats.fire_rate + 1,
	icon = preload("res://Items/icons/overcharge_capacitor_icon.png")
},
	27: {
	"Name" = "Lucky Charm",
	rarity = "common",
	pos_1 = "lucky_charm",
	icon = preload("res://Items/icons/lucky_charm_icon.png")
},

	28: {
	"Name" = "Better Scavenging",
	rarity = "common",
	pos_1 = "better_scav",
	icon = preload("res://Items/icons/better_scavenging_icon.png")
},

	29: {
	"Name" = "Fighter money increase",
	rarity = "common",
	pos_1 = "fighter_money",
	neg_1 = "fighter_damage",
	icon = preload("res://Items/icons/fighter_money_icon.png")
},

	30: {
	"Name" = "Bang for your Buck",
	rarity = "common",
	pos_1 = "bomber_money",
	neg_1 = "bomber_damage",
	icon = preload("res://Items/icons/bang_buck_icon.png")
},
31: {
	"Name" = "Heal kit",  # Different from "Heal Bot"
	rarity = "common",
	pos_1 = Player.Player_Stats.robomechanic + 1, 
	icon = preload("res://Items/icons/heal_kit_icon.png")
},
32: {
	"Name" = "Know The Enemy",
	rarity = "common",
	pos_1 = "know_enemy", 
	icon = preload("res://Items/icons/know_enemy_icon.png")
},
33: {
	"Name" = "Pilot's Instinct", 
	rarity = "common",
	pos_1 = Player.Player_Stats.maneuvering + 1,
	icon = preload("res://Items/icons/pilots_instinct_icon.png")
},
34: {
	"Name" = "Afterburner",
	rarity = "common",
	pos_1 = Player.Player_Stats.maneuvering + 1,
	pos_2 = Player.Player_Stats.speed + 1,
	neg_1 = Player.Player_Stats.armor - 1,
	icon = preload("res://Items/icons/afterburner_icon.png")
},
35: {
	"Name" = "Evasion Protocol",
	rarity = "common",
	pos_1 = Player.Player_Stats.maneuvering + 1,
	icon = preload("res://Items/icons/evasion_protocol_icon.png")
},
36: {
	"Name" = "Heavy Plating",
	rarity = "common",
	pos_1 = Player.Player_Stats.armor + 1,
	icon = preload("res://Items/icons/heavy_plating_icon.png")
},
}
var items_uncom = {

	0:{
		"Name" = "Magnet",
		rarity = "uncommon",
		pos_1 = "scrap",
		icon = preload("res://Items/icons/magnet_icon.png")
	},
	1:{
		"Name" = "Titanium Carbon Steel Reinforcement",
		rarity = "uncommon",
		pos_1 = Player.Player_Stats.health + 1,
		pos_2 = Player.Player_Stats.armor + 1,
		neg_1 = Player.Player_Stats.speed - 1,
		neg_2 = Player.Player_Stats.fire_rate - 1,
		icon = preload("res://Items/icons/Titanium_Carbon_Steel_Reinforcement.png")
	},
	2:{
		"Name" = "Sun juice", ## NEEDS IMPLEMENTED
		rarity = "uncommon",
		pos_1 = Player.Player_Stats.damage + 2,
		neg_1 = Player.Player_Stats.armor - 1,
		icon = preload("res://Items/icons/sun_juice_icon.png")
	},
	3: {
		"Name" = "Plate up",
		rarity = "uncommon",
		pos_1 = Player.Player_Stats.armor + 2,
		neg_1 = Player.Player_Stats.speed - 1,
		icon = preload("res://Items/icons/plate_up_icon.png")
	},

	4: {
		"Name" = "Bulwark",
		rarity = "uncommon",
		pos_1 = Player.Player_Stats.armor + 2,
		neg_1 = Player.Player_Stats.health - 1,
		"icon" = preload("res://Items/icons/bulwark_icon.png")
	},

	5: {
		"Name" = "Health ++",
		rarity = "uncommon",
		pos_1 = Player.Player_Stats.health + 2,
		neg_1 = Player.Player_Stats.armor - 1,
		 "icon" = preload("res://Items/icons/health_plus_plus_icon.png")
	},

	6: {
		"Name" = "Repair Pack",
		rarity = "uncommon",
		pos_1 = Player.Player_Stats.repair_kits + 3,
		"icon" = preload("res://Items/icons/repair_pack_icon.png")
	},

	7: {
		"Name" = "Missile",
		rarity = "uncommon",
		pos_1 = "missile",  # Needs special implementation
		icon = preload("res://Items/icons/missile_icon.png")
	},
	8: {
		"Name" = "Void Bomb",
		rarity = "uncommon",
		pos_1 = "void_bomb",  # Needs special implementation
		icon = preload("res://Items/icons/void_bomb_icon.png")
	},
	9: {
		"Name" = "Kill Counter",
		rarity = "uncommon",
		pos_1 = "kill_counter",  # Complex mechanic
		icon = preload("res://Items/icons/kill_counter_icon.png")
	},
	10: {
		"Name" = "Survivor's Resolve",
		rarity = "uncommon",
		pos_1 = "survivor",
		icon = preload("res://Items/icons/survivors_resolve_icon.png")
	},
}


var items_rares = {
	0:{
		"Name" = "Gel Impact", ## NEEDS IMPLEMENTED
		rarity = "rare",
		pos_1 = Player.Player_Stats.health + 1,
		icon = preload("res://Items/icons/gel_layer_icon.png")
	},
	1:{
		"Name" = "Friendly Memory Core Processing Unit Update",
		rarity = "rare",
		pos_1 = Player.Player_Stats.robo_ai_integrations + 2,
		neg_1 = Player.Player_Stats.damage - 1,
		icon = preload("res://Items/icons/Fiendly_Memory_Core_Processing_Unit_Update_icon.png")
	},

	2:{
		"Name" = "Hyper Turbo Boosters",
		rarity = "rare",
		pos_1 = Player.Player_Stats.speed + 3,
		neg_1 = Player.Player_Stats.health - 1,
		neg_2 = Player.Player_Stats.armor - 1,
		icon = preload("res://Items/icons/hyper_turbo_boosters_icon.png")
	},
	3: {
		"Name" = "Wormhole Drive",
		rarity = "rare",
		pos_1 = "wormhole",
		neg_1 = "no_minibots",
		icon = preload("res://Items/icons/wormhole_drive_icon.png")
	},
	4: {
		"Name" = "Charge Bolts",
		rarity = "rare",
		pos_1 = "charge_bolts",
		neg_1 = "no_unknown_substance",
		icon = preload("res://Items/icons/charge_bolts_icon.png")
},
}
var items_exceptional = {
	0:{
		"Name" = "Auto Blaster",
		rarity = "exceptional",
		pos_1 = Player.Player_Stats.fire_rate + 3,
		pos_2 = Player.Player_Stats.damage + 1,
		neg_1 = Player.Player_Stats.health - 2,
		icon = preload("res://Items/icons/Auto_Blaster_icon.png")
	},
	1:{
		"Name" = "Unknown Chaotic Substance",
		rarity = "exceptional",
		pos_1 = "Doubles Bolts",
		neg_1 = "Halves Damage",
		icon = preload("res://Items/icons/RUnknown_Chaotic_Substance_icon.png")
	},
}
	
