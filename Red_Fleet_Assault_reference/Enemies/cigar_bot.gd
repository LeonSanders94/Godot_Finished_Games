extends CharacterBody2D

@onready var explosion: AnimatedSprite2D = $Explosion
@onready var animated_sprite_2d = $Sprite2D
@onready var shoot_marker: Marker2D = $ShootMarker
@onready var shoot_marker_2: Marker2D = $ShootMarker2
@onready var shoot_marker_3: Marker2D = $ShootMarker3
@onready var ray_facing_right: RayCast2D = $ray_facing_right
@onready var ray_facing_left: RayCast2D = $ray_facing_left

@export var cigar_bullet = preload("res://Items/Bullets_explosions/cigar_bullet.tscn")
@export var scrap = preload("res://Items/scrap_tier_2.tscn")

# Constants
const UP_SPEED = 150.0
const DOWN_SPEED = 200.0
const SHOOT_INTERVAL = 2.5
const MAX_LIFETIME = 60.0
const DEATH_EXPLOSION_TIME = 0.5

# Enemy stats
var tier_cigar = {hp = 15, dmg = 4}
var hp: float
var red_member = RedFleet.belongs_in_RF

# Movement state
enum MovementDirection { UP, DOWN }
var current_direction = MovementDirection.DOWN  # Always start moving down
var movement_timer: float = 0.0
var direction_change_interval: float = 4.0

# Shooting
var shoot_timer: float = 0.0
var shoot_choice: float = 0.0

# Visual effects
var is_flashing: bool = false

# Timers
var lifetime_timer: float = 0.0

# Direction detection
var current_facing_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	hp = tier_cigar.hp + (Player.Wave * 2)
	
	# ALWAYS start moving down first
	current_direction = MovementDirection.DOWN
	
	shoot_timer = randf() * SHOOT_INTERVAL
	movement_timer = randf() * direction_change_interval
	shoot_choice = randi() % 4

func _physics_process(delta: float) -> void:
	lifetime_timer += delta
	shoot_timer -= delta
	movement_timer += delta
	
	# WAVE CLEANUP: Check for end of wave (like other enemies)
	if RedFleet.EOW or lifetime_timer >= MAX_LIFETIME:
		queue_free()
		return
	
	update_facing_direction()
	handle_vertical_movement(delta)
	
	if shoot_timer <= 0 and not Levels.paused:
		if shoot_choice == 0:
			shoot_horizontal()
			shoot_horizontal_TOP()
		if shoot_choice == 1:
			shoot_horizontal_TOP()
		if shoot_choice == 2:
			shoot_horizontal_TOP()
			shoot_horizontal_BOTTOM()
		if shoot_choice == 3:
			shoot_horizontal_BOTTOM()
			shoot_horizontal()
		shoot_timer = SHOOT_INTERVAL
	
	move_and_slide()

func update_facing_direction():
	# Since raycast detects the parent Area2D, just check if we're hitting ourselves
	if ray_facing_right and ray_facing_right.is_colliding():
		var right_collider = ray_facing_right.get_collider()
		if right_collider != self:  # If it's not our own Area2D
			current_facing_direction = Vector2.RIGHT
			print("Wall detected on right, shooting right")
	
	if ray_facing_left and ray_facing_left.is_colliding():
		var left_collider = ray_facing_left.get_collider()
		if left_collider != self:  # If it's not our own Area2D
			current_facing_direction = Vector2.LEFT
			print("Wall detected on left, shooting left")
func handle_vertical_movement(delta: float):
	if movement_timer >= direction_change_interval:
		movement_timer = 0.0
		if current_direction == MovementDirection.UP:
			current_direction = MovementDirection.DOWN
		else:
			current_direction = MovementDirection.UP
	
	match current_direction:
		MovementDirection.UP:
			velocity.y = -UP_SPEED
		MovementDirection.DOWN:
			velocity.y = DOWN_SPEED
	
	velocity.x = 0

# Replace your existing shoot functions with these:

func shoot_horizontal():
	if not cigar_bullet:
		return
	
	# Shoot first bullet immediately
	shoot_single_bullet(shoot_marker)
	
	# Schedule the other two with small delays
	await get_tree().create_timer(0.1).timeout
	shoot_single_bullet(shoot_marker)
	
	await get_tree().create_timer(0.1).timeout
	shoot_single_bullet(shoot_marker)
	
	print("Cigar bot finished burst of 3 bullets from main marker")

func shoot_horizontal_TOP():
	if not cigar_bullet:
		return
	
	# Shoot first bullet immediately
	shoot_single_bullet(shoot_marker_2)
	
	# Schedule the other two with small delays
	await get_tree().create_timer(0.1).timeout
	shoot_single_bullet(shoot_marker_2)
	
	await get_tree().create_timer(0.1).timeout
	shoot_single_bullet(shoot_marker_2)
	
	print("Cigar bot finished burst of 3 bullets from top marker")

func shoot_horizontal_BOTTOM():
	if not cigar_bullet:
		return
	
	# Shoot first bullet immediately
	shoot_single_bullet(shoot_marker_3)
	
	# Schedule the other two with small delays
	await get_tree().create_timer(0.1).timeout
	shoot_single_bullet(shoot_marker_3)
	
	await get_tree().create_timer(0.1).timeout
	shoot_single_bullet(shoot_marker_3)
	
	print("Cigar bot finished burst of 3 bullets from bottom marker")

func shoot_single_bullet(marker: Marker2D):
	var bullet = cigar_bullet.instantiate()
	get_tree().root.add_child(bullet)
	
	if marker:
		bullet.global_position = marker.global_position
	else:
		bullet.global_position = global_position
	
	bullet.set_direction(current_facing_direction)
func set_spawn_side(left_side: bool):
	if not left_side and animated_sprite_2d:
		animated_sprite_2d.flip_h = true

func damage_flash():
	if is_flashing:
		return
	
	is_flashing = true
	var tween = create_tween()
	
	tween.tween_property(animated_sprite_2d, "modulate", Color.RED * 1.5, 0.05)
	tween.tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.15)
	
	await tween.finished
	is_flashing = false

func take_damage(damage_amount: float):
	hp -= damage_amount
	Player.report.Damage_dealt += damage_amount
	damage_flash()
	
	if hp <= 0:
		Player.Player_Attributes.player_score += 100
		death()

func death():
	print("Cigar bot destroyed - Score: ", Player.Player_Attributes.player_score)
	Player.Player_Attributes.player_score += 50
	Player.report.Total_kills += 1
	
	animated_sprite_2d.hide()
	explosion.show()
	explosion.play('explode')
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(DEATH_EXPLOSION_TIME).timeout
	
	spawn_scrap()
	queue_free()

func spawn_scrap():
	if scrap:
		var sii = scrap.instantiate()
		get_tree().root.add_child(sii)  
		sii.transform = $ShootMarker.global_transform  
