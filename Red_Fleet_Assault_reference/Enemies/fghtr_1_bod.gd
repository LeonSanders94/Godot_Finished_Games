extends CharacterBody2D

@export var scrap = preload("res://Items/scrap.tscn")
@export var fighter_bolt = preload("res://Items/Bullets_explosions/basic_bolt_r_0.tscn")
@onready var right_cast: RayCast2D = $Right_cast
@onready var left_cast: RayCast2D = $Left_cast
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var tier_1 = RedFleet.Fleet_Attributes.tier_1
var hp = tier_1.hp + Player.Wave
var red_member = RedFleet.belongs_in_RF
var damage = Player.Player_Attributes.player_weapon_dmg
var triple_shot_count = 0
var is_alive: bool
var is_flashing: bool = false

# Timer replacements
var shoot_timer: float = 2.0
var lifetime_timer: float = 0.0

# Enhanced movement properties
enum MovementPattern {
	SIMPLE_SIDE_TO_SIDE,    # Original behavior
	SINE_WAVE,              # Smooth wave motion
	AGGRESSIVE_WEAVE,       # Sharp direction changes
	SPIRAL_DESCENT,         # Spiral while falling
	ERRATIC_DART           # Quick bursts in random directions
}

var movement_pattern: MovementPattern
var movement_timer: float = 0.0
var pattern_change_timer: float = 0.0
var pattern_change_interval: float = 4.0  # Change pattern every 4 seconds

# Movement state variables
var right: bool = false
var left: bool = false
var base_speed: float
var wave_amplitude: float = 80.0  # How wide the wave motion is
var wave_frequency: float = 2.0   # How fast the wave oscillates
var spiral_angle: float = 0.0
var spiral_radius: float = 60.0
var spawn_x: float  # Remember starting X position

# Erratic movement
var dart_timer: float = 0.0
var dart_duration: float = 0.3
var dart_direction: Vector2 = Vector2.ZERO
var is_darting: bool = false

# Animation tracking
var current_animation_direction: String = "default"  # Track current animation

func _ready() -> void:
	is_alive = true
	base_speed = tier_1.spd
	spawn_x = global_position.x
	set_meta("enemy_type", "fighter")
	# Randomly choose initial movement pattern based on wave
	choose_movement_pattern()
	
	# Set initial animation to default
	update_animation("default")

func choose_movement_pattern():
	# Higher waves get access to more complex patterns
	var available_patterns = [MovementPattern.SIMPLE_SIDE_TO_SIDE]
	
	if Player.Wave >= 2:
		available_patterns.append(MovementPattern.SINE_WAVE)
	if Player.Wave >= 4:
		available_patterns.append(MovementPattern.AGGRESSIVE_WEAVE)
	if Player.Wave >= 6:
		available_patterns.append(MovementPattern.SPIRAL_DESCENT)
	if Player.Wave >= 8:
		available_patterns.append(MovementPattern.ERRATIC_DART)
	
	movement_pattern = available_patterns[randi() % available_patterns.size()]
	print("Fighter using pattern: ", MovementPattern.keys()[movement_pattern])
	
	# Reset timers and state
	movement_timer = 0.0
	pattern_change_timer = 0.0
	spiral_angle = 0.0

func _physics_process(delta: float) -> void:
	# Timer updates
	shoot_timer -= delta
	lifetime_timer += delta
	movement_timer += delta
	pattern_change_timer += delta
	
	# Change movement pattern occasionally for variety
	if pattern_change_timer >= pattern_change_interval:
		choose_movement_pattern()
	
	# Shooting logic (unchanged)
	if shoot_timer <= 0 and is_alive and not Levels.paused:
		shoot()
		shoot_timer = 1.75
	
	# Enhanced movement system
	if is_alive:
		handle_enhanced_movement(delta)
	
	# Update animation based on movement
	update_movement_animation()
	
	move_and_slide()
	
	# Cleanup
	if RedFleet.EOW == true or lifetime_timer >= 30.0:
		queue_free()

func update_movement_animation():
	# Determine animation based on movement pattern and velocity
	var target_animation = "default"  # Default when not moving horizontally
	
	match movement_pattern:
		MovementPattern.SIMPLE_SIDE_TO_SIDE:
			# Use direction booleans for simple movement
			if left and not right:
				target_animation = "right"
			elif right and not left:
				target_animation = "left"
			else:
				target_animation = "default"  # Neither left nor right
		
		MovementPattern.SINE_WAVE, MovementPattern.AGGRESSIVE_WEAVE, MovementPattern.SPIRAL_DESCENT, MovementPattern.ERRATIC_DART:
			# Use velocity for complex movement patterns
			if velocity.x < -10:  # Moving left (with small threshold)
				target_animation = "right"
			elif velocity.x > 10:  # Moving right
				target_animation = "left"
			else:
				target_animation = "default"  # Not moving horizontally or very slow
	
	# Only update if animation changed
	if target_animation != current_animation_direction:
		update_animation(target_animation)

func update_animation(direction: String):
	if not animated_sprite_2d or not is_alive:
		return
	
	current_animation_direction = direction
	
	# Play appropriate animation
	if animated_sprite_2d.sprite_frames and animated_sprite_2d.sprite_frames.has_animation(direction):
		animated_sprite_2d.play(direction)
	else:
		print("Warning: '", direction, "' animation not found on fighter")

func handle_enhanced_movement(delta: float):
	var spd = base_speed
	
	# Always move downward
	velocity.y = spd
	
	# Apply movement pattern
	match movement_pattern:
		MovementPattern.SIMPLE_SIDE_TO_SIDE:
			handle_simple_movement()
		
		MovementPattern.SINE_WAVE:
			handle_sine_wave_movement(delta)
		
		MovementPattern.AGGRESSIVE_WEAVE:
			handle_aggressive_weave_movement(delta)
		
		MovementPattern.SPIRAL_DESCENT:
			handle_spiral_movement(delta)
		
		MovementPattern.ERRATIC_DART:
			handle_erratic_dart_movement(delta)

func handle_simple_movement():
	# Original side-to-side movement
	var spd = base_speed
	
	if right and not left:
		velocity.x = spd
	elif left and not right:
		velocity.x = -spd
	else:
		velocity.x = 0
	
	# Collision detection (original)
	if right_cast.is_colliding():
		right = false
		left = true
	elif left_cast.is_colliding():
		right = true
		left = false

func handle_sine_wave_movement(delta: float):
	# Smooth wave motion across screen
	var wave_offset = sin(movement_timer * wave_frequency) * wave_amplitude
	velocity.x = (spawn_x + wave_offset - global_position.x) * 3.0  # Smooth correction
	
	# Clamp to screen bounds
	velocity.x = clamp(velocity.x, -base_speed * 1.5, base_speed * 1.5)

func handle_aggressive_weave_movement(delta: float):
	# Sharp direction changes every 0.8 seconds
	var direction_change_interval = 0.8
	
	if fmod(movement_timer, direction_change_interval) < delta:
		# Change direction aggressively
		var direction_choice = randi() % 3
		match direction_choice:
			0: velocity.x = -base_speed * 1.2  # Fast left
			1: velocity.x = base_speed * 1.2   # Fast right
			2: velocity.x = 0                  # Stop briefly
	
	# Add collision detection
	if right_cast.is_colliding():
		velocity.x = -base_speed
	elif left_cast.is_colliding():
		velocity.x = base_speed

func handle_spiral_movement(delta: float):
	# Spiral motion while descending
	spiral_angle += delta * 3.0  # Rotation speed
	
	var spiral_x = cos(spiral_angle) * spiral_radius
	var target_x = spawn_x + spiral_x
	
	# Move toward spiral position
	velocity.x = (target_x - global_position.x) * 2.0
	velocity.x = clamp(velocity.x, -base_speed * 1.3, base_speed * 1.3)

func handle_erratic_dart_movement(delta: float):
	dart_timer += delta
	
	if not is_darting:
		# Start a new dart every 1-2 seconds
		if dart_timer >= randf_range(1.0, 2.0):
			start_dart()
	else:
		# Continue current dart
		velocity.x = dart_direction.x * base_speed * 1.5
		
		# End dart after duration
		if dart_timer >= dart_duration:
			end_dart()
	
	# Collision override
	if right_cast.is_colliding() or left_cast.is_colliding():
		end_dart()

func start_dart():
	is_darting = true
	dart_timer = 0.0
	dart_duration = randf_range(0.2, 0.5)
	
	# Choose random dart direction
	var dart_angle = randf_range(-PI/3, PI/3)  # -60 to +60 degrees
	dart_direction = Vector2(cos(dart_angle), 0).normalized()

func end_dart():
	is_darting = false
	dart_timer = 0.0
	velocity.x = 0

# Rest of the functions remain unchanged
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
		death()

func death():
	print(Player.Player_Attributes.player_score)
	Player.Player_Attributes.player_score += 2
	is_alive = false
	
	# Increment Kill Counter if player has it
	if Player.special_items.get("kill_counter", false):
		Player.kill_counter_stacks += 1
		print("Kill Counter: ", Player.kill_counter_stacks, " kills")
	
	# Rest of death function unchanged...
	$AnimatedSprite2D.hide()
	$".".disable_mode
	explosion.show()
	explosion.play('explode')
	$Explosion/AudioStreamPlayer2D.play()
	Player.report.Total_kills += 1
	Player.report.Fighter_kills += 1
	
	await get_tree().create_timer(0.5).timeout
	var si = scrap.instantiate()
	get_tree().root.add_child(si)
	si.transform = $Area2D.global_transform
	queue_free()
func shoot():
	var fb = fighter_bolt.instantiate()
	if is_alive and not Levels.paused:
		get_tree().root.add_child(fb)
		fb.transform = $Marker2D.global_transform
		
		# Handle triple shot logic
		triple_shot_count += 1
		if triple_shot_count >= 3:
			triple_shot_count = 0
			# Randomize direction for simple movement only
			if movement_pattern == MovementPattern.SIMPLE_SIDE_TO_SIDE:
				var r_or_l = randi() % 200
				if r_or_l >= 100:
					right = true
					left = false
				else:
					right = false
					left = true
