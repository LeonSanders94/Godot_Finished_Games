extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if RedFleet.belongs_in_RF:
		body.queue_free()
	queue_free()
