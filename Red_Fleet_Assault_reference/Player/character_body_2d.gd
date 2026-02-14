extends CharacterBody2D

@onready var mini_bot_spawn: Marker2D = $Mini_bot_spawn
@onready var player_ship: CharacterBody2D = $"."
@onready var player_a: AnimatedSprite2D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_layover: TextureRect = $"../camera/hurt_layover"
@export var mini_bot_scene: PackedScene
@export var basic_bolt: PackedScene
@onready var camera: Camera2D = $"../camera" 
@onready var game_over_screen = $"../camera/Game_over"  
const OLD_FAITHFUL_ANIMATION = preload("res://Player/old_faithful_animation.tres")
const ROYAL_SPEAR_ANIMATION = preload("res://Player/royal_spear_animation.tres")
const DRONE_BUS_ANIMATION = preload("res://Player/drone_bus_animation.tres")
const SPEED = Player.playerxy_spd 

var global_player_position = Player.Player_position 
var cooldown_frames = 0
var max_cooldown_frames = 12
var spawned_bots = 0
var regen_timer = 0.0
var regen_interval = 1.0  # Apply regen every 1 second

var is_dying = false
var death_center_duration = 1.0

# Mini-bot orbit properties
var orbit_radius = 80.0
var orbit_speed = 2.0
var orbit_time = 0.0
var mini_bots_array = []

# Animation states
enum AnimationState {
	DEFAULT,
	HURT,
	LEFT,
	RIGHT
}

var current_animation_state = AnimationState.DEFAULT
var hurt_timer = 0.0
var hurt_duration = 0.5
var is_hurt = false

func _ready() -> void:
	Player.Player_position = global_position  # Fixed assignment
	Powerups.ship_chooser_choise()  
	if Powerups.ship_choice == Powerups.weapons.basic:
		player_a.set_sprite_frames(OLD_FAITHFUL_ANIMATION)

	elif Powerups.ship_choice == Powerups.weapons.royal_spear:
		player_a.set_sprite_frames(ROYAL_SPEAR_ANIMATION)

	elif Powerups.ship_choice == Powerups.weapons.drone_Bus:
		player_a.set_sprite_frames(DRONE_BUS_ANIMATION)
		

	setup_animations()

func setup_animations():
	if player_a:
		if not player_a.sprite_frames:
			push_warning("No SpriteFrames resource found on Player AnimatedSprite2D")
			return
		play_animation("default")

func _physics_process(delta: float) -> void:
		# Start profiling
	if Debug.debug_enabled:
		Debug.start_timer("player_total")
		Debug.start_timer("player_minibots")
	
	handle_mini_bot_spawning()
	update_mini_bot_orbits(delta)
	
	if Debug.debug_enabled:
		Debug.end_timer("player_minibots")
		Debug.start_timer("player_regeneration")
	
	handle_hp_regeneration(delta)
	Handle_leech_overflow(delta)
	
	if Debug.debug_enabled:
		Debug.end_timer("player_regeneration")
		Debug.start_timer("player_movement_calc")
	
	if Debug.debug_enabled:
		Debug.start_timer("player_movement")
	
	var SPEED_up = SPEED - Player.speed_mod
	Player.Player_position = global_position  # Update once per frame
	
	# Handle hurt timer
	if is_hurt:
		hurt_timer -= delta
		if hurt_timer <= 0:
			is_hurt = false
			update_animation_state()
	
	# Get the input direction and handle the movement/deceleration.
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	
	# Handle horizontal movement and animations
	if direction_x:
		velocity.x = direction_x * SPEED_up
		if not is_hurt:
			if direction_x < 0:
				set_animation_state(AnimationState.LEFT)
			else:
				set_animation_state(AnimationState.RIGHT)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_up)
		if not is_hurt:
			set_animation_state(AnimationState.DEFAULT)
	
	# Handle vertical movement
	if direction_y:
		velocity.y = direction_y * SPEED_up
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED_up)
		
	if Debug.debug_enabled:
		Debug.start_timer("weapon_cooldown_check")
		Debug.start_timer("player_weapon_system")
	
	# Weapon cooldown
	if Player.Player_Attributes.weapon_cooldown > 0:
		Player.Player_Attributes.weapon_cooldown -= delta
	if Debug.debug_enabled:
		Debug.end_timer("weapon_cooldown_check")
		Debug.start_timer("weapon_shooting_check")
	if Debug.debug_enabled:
		Debug.start_timer("weapon_shoot_function")
	# Shooting
	if Input.is_action_pressed("shoot"):
		shoot()
		
	if Debug.debug_enabled:
		Debug.end_timer("weapon_shoot_function")

	if Debug.debug_enabled:
		Debug.end_timer("weapon_shooting_check")
	
	# Cheats
	if Input.is_action_just_pressed('wave_increase'):
		Player.Wave += 1
	if Input.is_action_pressed("add_money"):
		Player.money += 1000
	
	# Debug info
	if Input.is_action_just_pressed('debug'):
		print("FPS: ", Engine.get_frames_per_second())
		print("Memory: ", OS.get_static_memory_usage()/1024/1024, " MB")
		print("Current Animation State: ", AnimationState.keys()[current_animation_state])
		Debug.print_performance_report()
		Debug.snapshot()
	# Repair kit usage
	if Input.is_action_just_pressed('repair_kit'):
		if Player.Player_Attributes.player_current_HP < Player.Player_Attributes.player_hp_total - 19 and Player.Player_Stats.repair_kits > 0:
			Player.Player_Stats.repair_kits -= 1
			Player.Player_Attributes.player_current_HP += 20
		elif Player.Player_Stats.repair_kits == 0:
			pass
		else:
			pass

	
	move_and_slide()
	
	if Debug.debug_enabled:
		Debug.end_timer("player_physics")


func Handle_leech_overflow(delta: float):
	if Player.Player_Attributes.player_current_HP > Player.Player_Attributes.player_hp_total:
		Player.Player_Attributes.player_current_HP = Player.Player_Attributes.player_hp_total
func handle_hp_regeneration(delta: float):
	if Player.Player_Attributes.regen > 0:
		regen_timer += delta
		
		if regen_timer >= regen_interval:
			# Apply regeneration if player isn't at full health
			if Player.Player_Attributes.player_current_HP < Player.Player_Attributes.player_hp_total:
				var heal_amount = Player.Player_Attributes.regen
				Player.Player_Attributes.player_current_HP += heal_amount
				
				# Cap at maximum HP
				Player.Player_Attributes.player_current_HP = min(
					Player.Player_Attributes.player_current_HP, 
					Player.Player_Attributes.player_hp_total
				)
				
				print("Regenerated %d HP. Current HP: %d/%d" % [
					heal_amount,
					Player.Player_Attributes.player_current_HP,
					Player.Player_Attributes.player_hp_total
				])
			
			# Reset the timer
			regen_timer = 0.0
func set_animation_state(new_state: AnimationState):
	if current_animation_state != new_state:
		current_animation_state = new_state
		update_animation_state()

func update_animation_state():
	match current_animation_state:
		AnimationState.DEFAULT:
			play_animation("default")
			hurt_layover.hide()
		AnimationState.HURT:
			play_animation("hurt")
			hurt_layover.show()
		AnimationState.LEFT:
			play_animation("left")
			hurt_layover.hide()
		AnimationState.RIGHT:
			play_animation("right")
			hurt_layover.hide()

func play_animation(animation_name: String):
	if player_a and player_a.sprite_frames:
		if player_a.sprite_frames.has_animation(animation_name):
			player_a.play(animation_name)
		else:
			push_warning("Animation '%s' not found in SpriteFrames" % animation_name)
	
	if animation_player and animation_player.has_animation(animation_name):
		animation_player.play(animation_name)

func trigger_hurt_animation():
	is_hurt = true
	hurt_timer = hurt_duration
	set_animation_state(AnimationState.HURT)
	
	if animation_player and animation_player.has_animation("hurt_effects"):
		animation_player.play("hurt_effects")
	
	create_invincibility_effect()

func create_invincibility_effect():
	var tween = create_tween()
	tween.set_loops(int(hurt_duration * 10))
	tween.tween_property(player_a, "modulate:a", 0.3, 0.05)
	tween.tween_property(player_a, "modulate:a", 1.0, 0.05)
	tween.finished.connect(func(): player_a.modulate.a = 1.0)

func shoot():
	if Debug.debug_enabled:
		Debug.start_timer("shoot_cooldown_check")
	if Player.Player_Attributes.weapon_cooldown > 0:
		return
	
	if Debug.debug_enabled:
		Debug.end_timer("shoot_cooldown_check")
		Debug.start_timer("shoot_bolt_calculation")
	# Calculate total bolts (1 base + chaos bonus)
	var total_bolts = 1 + Player.chaos
	
	# Calculate spread angle if you want bolts to fan out
	var spread_angle = 15.0  # degrees between bolts
	var start_angle = -(total_bolts - 1) * spread_angle * 0.5
	if Debug.debug_enabled:
		Debug.end_timer("shoot_bolt_calculation")
		Debug.start_timer("shoot_bolt_creation")
	# Shoot all bolts
	for i in range(total_bolts):
		var bb = basic_bolt.instantiate()
		Player.report.Total_shots += 1
		
		owner.add_child(bb)
		bb.global_transform = $Marker2D.global_transform
		bb.global_rotation += deg_to_rad(start_angle + i * spread_angle)
		bb.global_position.x += (i - (total_bolts - 1) * 0.5) * 25 # 25 pixels apart
		
		if Debug.debug_enabled:
			Debug.end_timer("shoot_single_bolt")
	# Set cooldown once
	Player.Player_Attributes.weapon_cooldown = 0.2 - (Player.Player_Stats.fire_rate * 0.0075)
	
	if Debug.debug_enabled:
		Debug.end_timer("shoot_cooldown_set")
		Debug.start_timer("shoot_minibot_call")
	
	# Make orbiting bots shoot if chaos >= 1
	if Player.chaos >= 1:
		# Your orbiting bot logic here
		pass
	if Debug.debug_enabled:
		Debug.start_timer("weapon_minibot_shooting")
		
	shoot_mini_bots()
	if Debug.debug_enabled:
		Debug.end_timer("shoot_minibot_call")
	if Debug.debug_enabled:
		Debug.end_timer("weapon_minibot_shooting")
	if Debug.debug_enabled:
		Debug.end_timer("player_weapon_system")
func shoot_mini_bots():
	for bot in mini_bots_array:
		if is_instance_valid(bot) and bot.has_method("shoot_north"):
			bot.shoot_north()

func handle_mini_bot_spawning():
	var target_bots = Player.Player_Attributes.robos
	
	if target_bots > spawned_bots:
		while spawned_bots < target_bots:
			spawn_mini_bot()
			spawned_bots += 1
	elif target_bots < spawned_bots:
		remove_excess_mini_bots()
		spawned_bots = target_bots

func spawn_mini_bot():
	if not mini_bot_scene:
		push_error("Mini bot scene not assigned!")
		return
	
	var new_bot = mini_bot_scene.instantiate()
	if not new_bot:
		push_error("Failed to instantiate mini bot!")
		return
	
	add_child(new_bot)
	mini_bots_array.append(new_bot)
	new_bot.set_meta("bot_index", mini_bots_array.size() - 1)
	new_bot.set_meta("orbit_offset", 0.0)
	
	print("Mini bot spawned! Total bots: %d" % mini_bots_array.size())

func remove_excess_mini_bots():
	var target_bots = Player.Player_Attributes.robos
	
	while mini_bots_array.size() > target_bots:
		var bot_to_remove = mini_bots_array.pop_back()
		if is_instance_valid(bot_to_remove):
			bot_to_remove.queue_free()
	
	mini_bots_array = mini_bots_array.filter(func(bot): return is_instance_valid(bot))

func update_mini_bot_orbits(delta: float):
	if mini_bots_array.is_empty():
		return
	
	# Only update orbits every few frames for performance
	orbit_time += delta * orbit_speed
	
	# Cache expensive calculations
	var angle_per_bot = TAU / mini_bots_array.size()
	var player_pos = global_position
	
	for i in range(mini_bots_array.size()):
		var bot = mini_bots_array[i]
		if not is_instance_valid(bot):
			continue
		
		var current_angle = orbit_time + (angle_per_bot * i)
		
		# Use cached values
		var orbit_pos = Vector2(
			cos(current_angle) * orbit_radius,
			sin(current_angle) * orbit_radius
		)
		
		bot.global_position = player_pos + orbit_pos
		bot.rotation = -PI/2

func increase_money():
	Player.money += 3 + (Player.Wave * 2)
	Player.report.Total_Money_Collected += 3 + (Player.Wave * 2)

func increase_money_tier2():
	Player.money += 13 + (Player.Wave * 2)
	Player.report.Total_Money_Collected += 13 + (Player.Wave * 2)

func take_damage(damage: float):
	var thits = Player.report.Total_hits
	var tshots = Player.report.Total_shots
	var Accuracy = 0
	var dodge = randi() % 100
	
	if Player.Player_Attributes.player_shield_current < 1 and dodge > Player.Player_Stats.maneuvering:
		Player.Player_Attributes.player_current_HP -= damage - Player.Player_Stats.armor
		Player.report.Damage_taken += damage
		
		trigger_hurt_animation()
		
		if Player.Player_Attributes.player_current_HP <= 0:
			# Instead of immediately showing game over, start death sequence
			start_death_sequence()
	elif Player.Player_Attributes.player_shield_current > 0:
		Player.report.Damage_taken += damage
		Player.Player_Attributes.player_shield_current -= damage
		
		trigger_hurt_animation()
	elif Player.Player_Attributes.player_shield_current > 0:
		Player.report.Damage_taken += damage
		Player.Player_Attributes.player_shield_current -= damage
		
		trigger_hurt_animation()
		
		if Player.Player_Attributes.player_shield_current <= 0:
			pass
func start_death_sequence():
	$AnimatedSprite2D.hide()

	if is_dying:
		return  # Prevent multiple death sequences
	
	is_dying = true
	RedFleet.EOW = true
	# Stop player input and movement
	set_physics_process(false)
	velocity = Vector2.ZERO
	
	# Calculate accuracy for final stats
	if Player.report.Total_shots > 0:
		Player.report.Accuracy = float(Player.report.Total_hits) / float(Player.report.Total_shots)
	else:
		Player.report.Accuracy = 0.0
	
	# Start the death sequence
	await move_player_to_center()
	await play_death_animation()
	show_game_over()

func move_player_to_center():
	if camera and camera.has_method("get_screen_center_position"):
		var target_position = camera.get_screen_center_position()
		await move_to_position(target_position)
		return
		
func move_to_position(target_pos: Vector2):
	# Smoothly move player to the target position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", target_pos, death_center_duration)
	await tween.finished

func play_death_animation():
	# Play the death animation

	if player_a and player_a.sprite_frames:
		if player_a.sprite_frames.has_animation("death"):
			player_a.play("death")
			await player_a.animation_finished
		else:
			print("Warning: 'death' animation not found!")
			# Fallback - just wait a moment
			await get_tree().create_timer(1.0).timeout

func show_game_over():
	# Now show the game over screen
	get_tree().paused = true
	game_over_screen.show()
	Levels.paused = true
