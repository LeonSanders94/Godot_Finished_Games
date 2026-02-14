extends Node

###Contains all Player Attributes###

var model = 0 ## To be used for sprite selection ##
var Wave = 0
var money = 0
var Carrier_count = 2
var Player_position:Vector2
var speed_mod = 0
var chaos = 0
var bullet_control = 0
var Bullet_Limit = 100
var bonus = 0
var survivors_resolve_stacks = 0  # Track Survivor's Resolve stacks
var kill_counter_stacks = 0      # Track Kill Counter stacks
var special_items = {             # Track special item ownership
	"survivors_resolve": false,
	"kill_counter": false,
	"lucky_charm": false,
	"better_scavenging": false,
	"know_enemy": false
}
var scrap_money_bonus = 0          # Better Scavenging bonus
var scrap_money_multiplier = 1.0   # Lucky Charm multiplier  
var fighter_money_bonus = 0        # Fighter-specific bonus
var bomber_money_bonus = 0         # Bomber-specific bonus
var reinforced_hull_stacks = 0
var reinforced_hull_bonus_applied = 0
var fighter_damage_bonus = 0
var bomber_damage_bonus = 0
var kill_counter_kills = 0
var kill_counter_timer = 0.0
var kill_counter_active = false
var wave_delay = 0




##Player_Attrubytes should be modified by Player_Stats##
var Player_Attributes ={
	player_ship = 0, ## Ship Choice##
	player_score = 0,
	player_hp_total = 100, 
	player_current_HP = 100,
	player_alive = true,
	player_attk_dmg = 1,
	player_weapon_main = Powerups.weapons.basic,
	player_weapon_dmg = Powerups.weapons.basic.dmg,
	player_weapon_color = Powerups.weapons.basic.color_p,
	Bombs_remaining = 0,
	player_shield_max = 0,
	player_shield_current = 0,
	weapon_cooldown = 0,
	weapon_cooldown_max = 2,
	regen = 0,
	robos = 0,
	robo_dmg = 0.5,
	leech = 0,
	magnet = false,
	lucky_charm = false,
	better_scavenging = 0,
	fighter_money_bonus = 0,
	bomber_money_bonus = 0,
	survivor_resolve = false,
	know_the_enemy = false,
	afterburner = false
}
var Player_Stats ={
	health = 0,
	armor = 0,
	shield = 0,
	speed = 0,
	damage = 0,
	fire_rate = 0.0,
	robomechanic = 0,
	maneuvering = 0,
	robo_ai_integrations = 0, 
	life_steal = 0,
	repair_kits = 3,
	mag_size = 0
}
var report = {
	Total_kills = 0,
	Fighter_kills = 0,
	Bomber_kills = 0,
	Carrier_kills = 0,
	Total_hits = 1,
	Total_shots = 1 ,
	Accuracy = 0,
	Damage_taken = 0,
	Damage_dealt = 0,
	Total_Money_Collected = 0,

}
const player_spd = 10 ##parralax##
const playerxy_spd = 400 ##Player Speed##
const is_player = true
