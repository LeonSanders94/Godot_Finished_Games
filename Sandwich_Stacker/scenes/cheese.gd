extends CharacterBody2D

@export var fall_speed: float = 200.0
var is_caught: bool = false

@onready var player_platform: Node2D = %Player_platform
@onready var follow_me: RemoteTransform2D = $"../../Player_platform/follow_me"

func _ready():
	# Make sure gravity is applied
	velocity.y = fall_speed


func _physics_process(delta):
	if not is_caught:
		velocity.y = fall_speed
		move_and_slide()
	print(self.position)

func catch_block():
	is_caught = true
	velocity = Vector2.ZERO
	follow_me.update_position = true
	
