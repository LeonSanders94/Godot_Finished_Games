extends CharacterBody2D

@onready var carrier: CharacterBody2D = $"."
@onready var top_r_gun = $top_r_gun
@onready var top_l_gun: AnimatedSprite2D = $top_l_gun
@onready var bottom_r_gun: AnimatedSprite2D = $bottom_r_gun
@onready var bottom_l_gun: AnimatedSprite2D = $bottom_l_gun

@export var carrier_bolt = preload("res://Items/Bullets_explosions/basic_bolt_r_0.tscn")

var tier_1 = RedFleet.Fleet_Attributes.tier_4
var hp = tier_1.hp

func take_damage(damage: float):
	hp -= damage
	Player.report.Damage_dealt += damage
	if hp <= 0:
		Player.report.Total_kills += 1
		Player.report.Carrier_kills += 1
		
		queue_free()


	#print(self,'pew!')
