extends CharacterBody2D

@onready var linus_sprite = $linus_sprite
@onready var ouch: AudioStreamPlayer2D = $ouch
@onready var slime_body: CharacterBody2D = $slime_body
@onready var offlab: Label = $off




const SPEED = 300.0
const JUMP_VELOCITY = -350.0

var slimepos = McpGlobal.slimepos
var is_hurt = 0
var meat_score = McpGlobal.meat_score
var is_jumping = false
var is_moving = false
var is_idle = true
var x = 0


@onready var hearts = $Health/health

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = true

	elif is_on_floor():
		is_jumping = false
	if Input.is_action_just_pressed("score"):
		#McpGlobal.Winner_count += 1
		print('Winner count:',McpGlobal.Winner_count)
		print('meat score:',McpGlobal.meat_score)
		print('victory score:',McpGlobal.victory_score)
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")

	
##Damage##
	if McpGlobal.slime_damage == true:
		velocity.y = JUMP_VELOCITY
		is_hurt = 1
		print('hurt! in ##Damage##')
		linus_sprite.play('hurt')
		ouch.play()
##Moving##
	elif direction:
		is_moving = true
		velocity.x = direction * SPEED
		#print(velocity.x)
##Idle##
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		is_moving = false
		#print(velocity.x)
##h-flips##
	if velocity.x == -300:
		linus_sprite.flip_h = true
	if velocity.x == 300:
		linus_sprite.flip_h = false

	move_and_slide()
func _process(delta):
###States of Movement##
	if is_jumping == true:
		linus_sprite.play("jumping")
		#print("I am Jumping!")
		McpGlobal.linus_jump = true
	elif is_moving == true:
		linus_sprite.play('moving')
		#print("I am moving!")
	elif is_idle == true:
		linus_sprite.play("idle")
		#print("I am Idle!")
	elif is_hurt == 1:
		is_moving == false

###MCP Globals for handling the hearts and 'is hurt status
	if McpGlobal.Linus_health == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	if McpGlobal.winner == true:
		get_tree().change_scene_to_file("res://winner.tscn")
	if McpGlobal.Linus_health == 3:
		hearts.play('3')
	if McpGlobal.Linus_health == 2:
		#print(is_hurt)
		hearts.play('2')
	if McpGlobal.Linus_health == 1:
		hearts.play('1')
	if McpGlobal.off == 1:
		offlab.show()
	if McpGlobal.off == 0:
		offlab.hide()
