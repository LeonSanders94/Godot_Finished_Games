# CombatUtils.gd - Save this file and add as autoload singleton
extends Node

# Shared damage flash effect - used by ALL enemies
func damage_flash(entity: Node, sprite_node: Node = null) -> void:
	# Auto-find sprite if not provided
	if sprite_node == null:
		sprite_node = entity.get_node_or_null("AnimatedSprite2D") 
		if sprite_node == null:
			sprite_node = entity.get_node_or_null("Sprite2D")
	
	if sprite_node == null:
		return
		
	# Prevent multiple flashes
	if sprite_node.has_meta("is_flashing") and sprite_node.get_meta("is_flashing"):
		return
	
	sprite_node.set_meta("is_flashing", true)
	
	var tween = sprite_node.create_tween()
	tween.tween_property(sprite_node, "modulate", Color.RED * 1.5, 0.05)
	tween.tween_property(sprite_node, "modulate", Color.WHITE, 0.15)
	
	await tween.finished
	sprite_node.set_meta("is_flashing", false)

# Standardized enemy take_damage function
func enemy_take_damage(entity: Node, damage: float, hp_property: String = "hp") -> bool:
	"""
	Standard enemy damage handling. Returns true if enemy died.
	"""
	var current_hp = entity.get(hp_property)
	current_hp -= damage
	entity.set(hp_property, current_hp)
	
	# Update player stats
	Player.report.Damage_dealt += damage
	Player.report.Total_hits += 1
	
	# Trigger damage flash
	damage_flash(entity)
	
	# Check for death
	return current_hp <= 0

# Standardized death explosion sequence
func death_explosion(entity: Node, base_score: int = 0) -> void:
	"""
	Standard death sequence: scoring, explosion, sound, cleanup
	"""
	# Add score
	if base_score > 0:
		Player.Player_Attributes.player_score += base_score
		Player.report.Total_kills += 1
	
	# Hide main sprite
	var sprite = entity.get_node_or_null("AnimatedSprite2D")
	if sprite == null:
		sprite = entity.get_node_or_null("Sprite2D")
	if sprite:
		sprite.hide()
	
	# Show explosion
	var explosion = entity.get_node_or_null("Explosion")
	if explosion:
		explosion.show()
		if explosion.has_method("play"):
			explosion.play("explode")
	
	# Play death sound
	var audio = entity.get_node_or_null("AudioStreamPlayer2D")
	if audio:
		audio.play()
	
	# Wait for explosion
	await entity.get_tree().create_timer(0.5).timeout

# Standardized scrap spawning
func spawn_scrap(entity: Node, scrap_scene: PackedScene) -> void:
	"""
	Spawn scrap at entity's marker position
	"""
	if not scrap_scene:
		return
	
	# Find spawn position
	var marker = entity.get_node_or_null("Marker2D")
	if marker == null:
		marker = entity.get_node_or_null("Area2D")
	
	var spawn_position = entity.global_position
	if marker:
		spawn_position = marker.global_position
	
	# Spawn scrap
	var scrap_instance = scrap_scene.instantiate()
	entity.get_tree().root.add_child(scrap_instance)
	scrap_instance.global_position = spawn_position

# Complete enemy death with scoring and scrap
func enemy_death(entity: Node, base_score: int, scrap_scene: PackedScene = null, enemy_type: String = "") -> void:
	"""
	Complete enemy death sequence
	"""
	# Update kill statistics
	if enemy_type != "":
		match enemy_type:
			"fighter":
				Player.report.Fighter_kills += 1
			"bomber":
				Player.report.Bomber_kills += 1
			"carrier":
				Player.report.Carrier_kills += 1
	
	# Death explosion sequence
	await death_explosion(entity, base_score)
	
	# Spawn scrap
	if scrap_scene:
		spawn_scrap(entity, scrap_scene)
	
	# Clean up
	entity.queue_free()

# Bullet cleanup utility
func should_cleanup_bullet(lifetime_timer: float, max_lifetime: float = 3.0) -> bool:
	"""
	Standard bullet cleanup check
	"""
	return lifetime_timer >= max_lifetime or RedFleet.EOW

# Wave-based stat scaling
func scale_by_wave(base_value: float, scale_factor: float = 0.5) -> float:
	"""
	Standard wave scaling formula
	"""
	return base_value + (Player.Wave * scale_factor)
