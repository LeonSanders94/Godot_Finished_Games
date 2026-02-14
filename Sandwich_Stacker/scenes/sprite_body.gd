extends CharacterBody2D

const SPEED = 400.0

@onready var catch_zone: Area2D = $catch_zone

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if Input.is_action_pressed("left"):
			$SandwichGu.flip_h = true
			$SandwichGu.offset.x = 48
		if Input.is_action_pressed("right"):
			$SandwichGu.flip_h = false
			$SandwichGu.offset.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()
