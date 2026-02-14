extends CharacterBody2D

const SPEED = 50.0
@onready var right_cast = $right_cast
@onready var left_cast = $left_cast
@onready var slime_body = $slime_ani

@onready var linus = %Linus
@onready var slime_hurt_u: Area2D = $slime_hurt_u



func _process(delta) -> void:
	#print(slime_hurt_u.global_position)  
	var slimepos = slime_hurt_u.global_position
	McpGlobal.slimepos = slimepos
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor() and velocity.x == 0:
		velocity.x = SPEED
		slime_body.play('moving')

	if right_cast.is_colliding():
		#print("I'm COLLIDING WITH THE RIGHT")
		velocity.x *= -1
	elif left_cast.is_colliding():
		velocity.x *= -1
		#print("I'm COLLIDING WITH THE LEFT")
	move_and_slide()
	

func _on_slime_hurt_u_body_entered(linus) -> void:
	McpGlobal.Linus_health -= 1
	#print('Hurting you!')                                                           
	McpGlobal.slime_damage = true
	#print(McpGlobal.slime_damage)
	


func _on_slime_hurt_u_body_exited(body: Node2D) -> void:
	if McpGlobal.linus_jump == true:
		McpGlobal.slime_damage = false
