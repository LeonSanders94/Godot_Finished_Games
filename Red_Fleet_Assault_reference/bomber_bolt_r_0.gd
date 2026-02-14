extends Area2D


@onready var basic_an = $basic_red
var speed = 150
var color = 'red'



func _physics_process(delta):
	position -= transform.y * speed * delta
	if RedFleet.EOW == true:
		queue_free()
func _proccess(delta):
	if color == 'red' :
		basic_an.play('red')



func _on_body_entered(body: Node2D) -> void:
	if Debug.debug_enabled:
		Debug.start_timer("player_bullet_physics")
	if Player.is_player == true and body.has_method("take_damage"):
		print('Gotcha!')
		body.queue_free()
	queue_free()
	if Debug.debug_enabled:
		Debug.end_timer("player_bullet_physics")
