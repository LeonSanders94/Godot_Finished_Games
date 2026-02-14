extends CharacterBody2D

@onready var bomber_1_bod: CharacterBody2D = $"."
@export var Bomber_Bolt = preload("res://Items/Bullets_explosions/bomber_bolt_r_0.tscn")
@export var scrap = preload("res://Items/scrap_tier_2.tscn")
@onready var right_cast: RayCast2D = $right_cast
@onready var left_cast: RayCast2D = $left_cast
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var tier_2 = RedFleet.Fleet_Attributes.tier_2
var hp = tier_2.hp + Player.Wave
var red_member = RedFleet.belongs_in_RF
var right: bool
var left: bool
var damage = Player.Player_Attributes.player_weapon_dmg
var is_flashing: bool = false

# Timer replacements (ONLY change)
var shoot_timer: float = 2.0  # Initial delay
var lifetime_timer: float = 0.0

# Animation tracking
var current_animation_direction: String = "default"  # Track current animation

func _ready() -> void:
	# Set initial direction
	var r_or_l = randi() % 200
	if r_or_l >= 100:
		right = true
		left = false
	elif r_or_l <= 200:
		right = false
		left = true
	set_meta("enemy_type", "bomber")
	# Set initial animation to default
	update_animation("default")

func _physics_process(delta: float) -> void:
	# Timer updates (ONLY change)
	shoot_timer -= delta
	lifetime_timer += delta

	# Original shooting logic
	if shoot_timer <= 0 and not Levels.paused:
		shoot()
		shoot_timer = 1.8  # Cooldown
		# Randomize direction after shooting
		var r_or_l = randi() % 200
		if r_or_l >= 100:
			right = true
			left = false
		elif r_or_l <= 200:
			right = false
			left = true
	
	# Original movement (unchanged)
	var spd = tier_2.spd
	velocity.y = spd 
	if right == true and left == false:
		velocity.x = spd
	elif right == false and left == true:
		velocity.x = -spd
	else:
		velocity.x = 0  # Fixed: was == instead of =
		
	if right_cast.is_colliding():
		right = false
		left = true
	elif left_cast.is_colliding():
		right = true
		left = false
	
	# Update animation based on movement direction
	update_movement_animation()
	
	move_and_slide()
	
	# Cleanup (replaces _process timer hell)
	if RedFleet.EOW == true or lifetime_timer >= 30.0:
		queue_free()

func update_movement_animation():
	# Determine animation based on direction booleans
	var target_animation = "default"  # Default when not moving horizontally
	
	if left and not right:
		target_animation = "left"
	elif right and not left:
		target_animation = "right"
	else:
		target_animation = "default"  # Neither left nor right
	
	# Only update if animation changed
	if target_animation != current_animation_direction:
		update_animation(target_animation)

func update_animation(direction: String):
	if not animated_sprite_2d:
		return
	
	current_animation_direction = direction
	
	# Play appropriate animation
	if animated_sprite_2d.sprite_frames and animated_sprite_2d.sprite_frames.has_animation(direction):
		animated_sprite_2d.play(direction)
	else:
		print("Warning: '", direction, "' animation not found on bomber")

func damage_flash():
	if is_flashing:
		return
	
	is_flashing = true
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate", Color.RED * 1.5, 0.05)
	tween.tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.15)
	
	await tween.finished
	is_flashing = false

func take_damage(damage: float):
	hp -= damage
	Player.report.Damage_dealt += damage
	damage_flash()
	
	if hp <= 0:
		print(Player.Player_Attributes.player_score)
		Player.Player_Attributes.player_score += 250
		death()

func death():
	Player.Player_Attributes.player_score += 2
	
	# Increment Kill Counter if player has it
	if Player.special_items.get("kill_counter", false):
		Player.kill_counter_stacks += 1
		print("Kill Counter: ", Player.kill_counter_stacks, " kills")
	
	# Rest of death function unchanged...
	$AnimatedSprite2D.hide()
	explosion.show()
	explosion.play('explode')
	Player.report.Total_kills += 1
	Player.report.Bomber_kills += 1
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	var sii = scrap.instantiate()
	get_tree().root.add_child(sii)
	sii.transform = $Marker2D.global_transform
	queue_free()
func shoot():
	var bb1 = Bomber_Bolt.instantiate()
	if Levels.paused == false:
		get_tree().root.add_child(bb1)  # Original working method
		bb1.transform = $Marker2D.global_transform  # Original working method
