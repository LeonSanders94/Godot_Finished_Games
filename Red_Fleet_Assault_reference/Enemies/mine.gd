extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_chaser: Area2D = $player_chaser
@onready var hurt_area: Area2D = $hurt_area  # New hurt detection area
@onready var explosion: AnimatedSprite2D = $Explosion

# Constants (following your fighter pattern)
const FALL_SPEED = 200.0  # Slower than fighter base speed
const CHASE_SPEED = 350.0  # Faster when chasing player
var  DAMAGE_AMOUNT = 10.0 * Player.Wave  # Damage to player on contact
const MAX_LIFETIME = 30.0  # Same as fighter
const DEATH_EXPLOSION_TIME = 0.5  # Same as fighter
const ROTATION_SPEED = 1.0  # Radians per second for slow rotation
const PULSE_SPEED = 2.0  # Speed of red pulsing effect

# Enemy stats (following your fighter pattern)
var tier_mine = {hp = 1, spd = FALL_SPEED}
var hp: float
var red_member = RedFleet.belongs_in_RF
var damage = Player.Player_Attributes.player_weapon_dmg

# States
enum MineState { FALLING, CHASING, EXPLODING }
var current_state = MineState.FALLING
var is_alive: bool = true

# Visual effects (following your fighter pattern)
var is_flashing: bool = false
var pulse_timer: float = 0.0

# Timers (following your fighter pattern)
var lifetime_timer: float = 0.0

func _ready() -> void:
	# Initialize HP with wave scaling (like fighter)
	hp = tier_mine.hp + (Player.Wave * 0.5)  # Slight wave scaling
	is_alive = true
	
	# Connect player detection area (for chasing)
	if player_chaser:
		player_chaser.body_entered.connect(_on_player_chaser_body_entered)
	
	# Connect hurt area (for damage/explosion)
	if hurt_area:
		hurt_area.body_entered.connect(_on_hurt_area_body_entered)

func _physics_process(delta: float) -> void:
	# Timer updates (like fighter)
	lifetime_timer += delta
	pulse_timer += delta
	
	# Check for cleanup conditions (like fighter)
	if RedFleet.EOW or lifetime_timer >= MAX_LIFETIME:
		death()
		return
	
	# Handle movement based on state
	if is_alive:
		match current_state:
			MineState.FALLING:
				handle_falling_movement()
			MineState.CHASING:
				handle_chasing_movement(delta)
			MineState.EXPLODING:
				# No movement during explosion
				pass
	
	# Visual effects
	handle_visual_effects(delta)
	
	move_and_slide()

func handle_falling_movement():
	# Normal downward movement (like fighter base movement)
	velocity.y = tier_mine.spd
	velocity.x = 0

func handle_chasing_movement(delta: float):
	# Chase the player (similar to your existing patterns)
	var player = get_tree().get_first_node_in_group("Playergroup")
	if not player:
		# Fall back to falling if no player found
		current_state = MineState.FALLING
		return
	
	# Move toward player at chase speed
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * CHASE_SPEED

func handle_visual_effects(delta: float):
	if not sprite_2d or not is_alive:
		return
	
	# Slow rotation
	sprite_2d.rotation += ROTATION_SPEED * delta
	
	# Red pulsing effect (modulating between white and light red)
	if not is_flashing:  # Don't interfere with damage flash
		var pulse_intensity = (sin(pulse_timer * PULSE_SPEED) + 1.0) / 2.0  # 0 to 1
		var red_tint = Color.WHITE.lerp(Color(1.0, 0.8, 0.8, 1.0), pulse_intensity * 0.3)
		sprite_2d.modulate = red_tint

func _on_player_chaser_body_entered(body: Node2D):
	# Start chasing when player enters detection area
	if body.is_in_group("Playergroup") and current_state == MineState.FALLING:
		current_state = MineState.CHASING
		print("Mine activated - chasing player!")

func _on_hurt_area_body_entered(body: Node2D):
	# Explode on contact with player (hurt area collision)
	if body.is_in_group("Playergroup") and current_state != MineState.EXPLODING and is_alive:
		explode_and_damage_player(body)

func explode_and_damage_player(player_body: Node2D):
	print("Mine exploding on contact!")
	
	# Deal damage to player
	if player_body.has_method("take_damage"):
		player_body.take_damage(DAMAGE_AMOUNT) 
	
	# Trigger death/explosion
	death()

func damage_flash():
	# Damage flash effect (exactly like fighter)
	if is_flashing:
		return
	
	is_flashing = true
	var tween = create_tween()
	
	tween.tween_property(sprite_2d, "modulate", Color.RED * 1.5, 0.05)
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.15)
	
	await tween.finished
	is_flashing = false

func take_damage(damage_amount: float):
	# Can be destroyed by player bullets (like fighter)
	if not is_alive:
		return
		
	hp -= damage_amount
	Player.report.Damage_dealt += damage_amount
	damage_flash()
	
	if hp <= 0:
		death()

func death():
	# Always explode on death (like fighter death pattern)
	if not is_alive:
		return  # Prevent double death
		
	print("Mine destroyed - Score: ", Player.Player_Attributes.player_score)
	Player.Player_Attributes.player_score += 25  # Small score for mine
	Player.report.Total_kills += 1
	# Note: Could add mine-specific kill tracking if needed
	
	is_alive = false
	
	# Hide sprite and show explosion (exactly like fighter)
	sprite_2d.hide()
	explosion.show()
	explosion.play('explode')
	$AudioListener2D.play()
	
	# Wait for explosion to finish (like fighter)
	await get_tree().create_timer(DEATH_EXPLOSION_TIME).timeout
	
	# NO SCRAP SPAWNING (as requested - commented out)
	# var si = scrap.instantiate()
	# get_tree().root.add_child(si)
	# si.transform = $Area2D.global_transform
	
	# Clean up
	queue_free()
