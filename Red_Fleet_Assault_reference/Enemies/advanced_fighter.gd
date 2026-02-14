extends CharacterBody2D

@onready var advanced_fighter: CharacterBody2D = $"."

@onready var right_cast: RayCast2D = $Right_cast
@onready var left_cast: RayCast2D = $Left_cast
@onready var level_1: Node2D = $"../.."
@onready var Adv_pos = level_1.Adv_pos

var tier_1 = {
		dmg = 5,
		hp = 200,
		spd = randi() % 100 + 90,
		color = 'red',
		}

var right:bool
var left:bool
var stopper:bool
var Adv_posf:Vector2
var red_member = RedFleet.belongs_in_RF


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	#shoot() 
	move_randomizer()
func _process(delta):
	if $".".in_zone == true:
		stopper = false

func _physics_process(delta: float) -> void:
	var spd = tier_1.spd
	if stopper == false:
		velocity = position.direction_to(Adv_posf) * spd
	elif advanced_fighter.global_position == Adv_posf:
		stopper == true
	if stopper == true:
		velocity.y = 0
		velocity.x = 0
	move_and_slide()

func take_damage(damage: float):
	tier_1.hp -= damage
	if tier_1.hp <= 0:
		queue_free()

func cooldown():
	await get_tree().create_timer(2.5).timeout
	stopper == true
	await get_tree().create_timer(2.5).timeout
	move_randomizer()
	print("Chosen Postision",Adv_posf)
	print("All Level Cords",Adv_pos)

#func shoot():
	#await get_tree().create_timer(1.5).timeout
	#var fb = fighter_bolt.instantiate()
	#get_tree().root.add_child(fb)
	#fb.transform = $Marker2D.global_transform
	#cooldown()
	#print(self,'pew!')

func move_randomizer():
	cooldown()
	stopper = false
	var pos_select = 0
	print('pos_select',pos_select)
	if pos_select == 0:
		Adv_posf = Adv_pos.advp1
	elif pos_select == 1:
		Adv_posf = Adv_pos.advp2
	elif pos_select == 2:
		Adv_posf = Adv_pos.advp3
	elif pos_select == 3:
		Adv_posf = Adv_pos.advp4
	elif pos_select == 4:
		Adv_posf = Adv_pos.advp5
	elif pos_select == 5:
		Adv_posf = Adv_pos.advp6
	elif pos_select == 6:
		Adv_posf = Adv_pos.advp7
	elif pos_select == 7:
		Adv_posf = Adv_pos.advp8
	elif pos_select == 8:
		Adv_posf = Adv_pos.advp9
	elif pos_select == 9:
		Adv_posf = Adv_pos.advp10
	elif pos_select == 10:
		Adv_posf = Adv_pos.advp11
	elif pos_select == 11:
		Adv_posf = Adv_pos.advp12
	elif pos_select == 12:
		Adv_posf = Adv_pos.advp13
	elif pos_select == 13:
		Adv_posf = Adv_pos.advp14
	elif pos_select == 14:
		Adv_posf = Adv_pos.advp15
	elif pos_select == 15:
		Adv_posf = Adv_pos.advp16
	elif pos_select == 16:
		pass
