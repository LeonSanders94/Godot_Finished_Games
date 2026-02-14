extends Area2D

var speed = 800.0  # Fast horizontal speed
var direction = Vector2.RIGHT  # Set by cigar bot
var y_direction = Vector2.DOWN
var y_speed = 200.0  # Y movement speed
var lifetime_timer = 0.0
var max_lifetime = 3.0

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()

func _physics_process(delta):
	# Simple movement - just go in the direction the cigar bot told us
	position += direction * speed * delta
	
	# Move vertically (falling down)
	position += y_direction * y_speed * delta
	
	# Update lifetime
	lifetime_timer += delta
	
	# WAVE CLEANUP: Same as other enemy bullets
	if lifetime_timer >= max_lifetime or RedFleet.EOW == true:
		queue_free()

func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		print('Cigar bullet hit player!')  # Like other enemy bullets
		body.take_damage(4.0)  # Cigar bot damage
		queue_free()  # Bullet disappears after hitting player
