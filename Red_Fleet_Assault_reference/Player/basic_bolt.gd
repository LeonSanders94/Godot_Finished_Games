extends Area2D

@onready var basic_an = $basic
@export var damage: float
var speed = 700
var color = 'blue'
var dmg = Player.Player_Attributes.player_weapon_dmg
var bullet_limit = Player.Bullet_Limit
var bullet_control = Player.bullet_control

# Timer replacement
var lifetime_timer: float = 0.0
var max_lifetime: float = 2.0

func _ready():
	dmg = Player.Player_Attributes.player_weapon_dmg
	$shoot_sound.play()
	# Set lifetime based on bullet control (original logic)
	if bullet_control <= bullet_limit:
		max_lifetime = 2.0
	else:
		max_lifetime = 0.5

func _physics_process(delta):
	if Debug.debug_enabled:
		Debug.start_timer("player_bullet_physics")
	if RedFleet.EOW == true:
		queue_free()
	position -= transform.y * speed * delta
	
	lifetime_timer += delta
	if lifetime_timer >= max_lifetime or RedFleet.EOW == true:
		queue_free()
	
	if Debug.debug_enabled:
		Debug.end_timer("player_bullet_physics")

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("take_damage"):
		var base_damage = dmg
		var final_damage = base_damage
		
		# Determine enemy type for bonuses (check the body's script or name)
		var enemy_type = get_enemy_type(body)
		
		# Apply enemy-specific damage bonuses
		final_damage = apply_enemy_damage_bonuses(final_damage, enemy_type)
		
		# Apply Survivor's Resolve bonus
		if Player.special_items.get("survivors_resolve", false) and Player.survivors_resolve_stacks > 0:
			var health_percent = float(Player.Player_Attributes.player_current_HP) / float(Player.Player_Attributes.player_hp_total)
			if health_percent < 0.5:
				final_damage *= 1.5
				print("Survivor's Resolve: 1.5x damage! (", final_damage, " damage)")
		
		# Apply Kill Counter bonus
		if Player.special_items.get("kill_counter", false) and Player.kill_counter_stacks > 0:
			var bonus_damage = Player.kill_counter_stacks * 0.5
			final_damage += bonus_damage
			print("Kill Counter: +", bonus_damage, " damage! (Total: ", final_damage, ")")
		
		# Apply the damage
		damage = final_damage
		body.take_damage(damage)
		
		# Apply life steal
		if Player.Player_Attributes.leech > 0:
			var heal_amount = 0.5 + (Player.Player_Attributes.leech * 0.1)
			
			if Player.Player_Attributes.player_current_HP < Player.Player_Attributes.player_hp_total:
				var new_hp = Player.Player_Attributes.player_current_HP + heal_amount
				Player.Player_Attributes.player_current_HP = min(new_hp, Player.Player_Attributes.player_hp_total)
				
				var actual_heal = Player.Player_Attributes.player_current_HP - (new_hp - heal_amount)
				print("Life steal: +%.1f HP (Current: %.1f/%.1f)" % [
					actual_heal, 
					Player.Player_Attributes.player_current_HP, 
					Player.Player_Attributes.player_hp_total
				])
		
		queue_free()

# FIXED: Helper function to determine enemy type
func get_enemy_type(body: CharacterBody2D) -> String:
	# Check the body's name or script to determine enemy type
	var body_name = body.name.to_lower()
	var script_path = ""
	
	if body.get_script():
		script_path = body.get_script().resource_path.to_lower()
	
	# Determine enemy type based on name or script
	if "fighter" in body_name or "fghtr" in body_name or "fighter" in script_path:
		return "fighter"
	elif "bomber" in body_name or "bomber" in script_path:
		return "bomber"
	elif "cigar" in body_name or "cigar" in script_path:
		return "cigar_bot"
	elif "mine" in body_name or "mine" in script_path:
		return "mine"
	else:
		return "unknown"

# FIXED: Apply enemy-specific damage bonuses (removed Player.has() calls)
func apply_enemy_damage_bonuses(base_damage: float, enemy_type: String) -> float:
	var final_damage = base_damage
	
	# Apply enemy-specific damage bonuses using 'in' operator
	match enemy_type:
		"fighter":
			if "fighter_damage_bonus" in Player and Player.fighter_damage_bonus > 0:
				final_damage += Player.fighter_damage_bonus
				print("Fighter bonus: +", Player.fighter_damage_bonus, " damage (Total: ", final_damage, ")")
		"bomber":
			if "bomber_damage_bonus" in Player and Player.bomber_damage_bonus > 0:
				final_damage += Player.bomber_damage_bonus
				print("Bomber bonus: +", Player.bomber_damage_bonus, " damage (Total: ", final_damage, ")")
		"cigar_bot":
			# Could add cigar bot specific bonuses here if needed
			pass
		"mine":
			# Could add mine specific bonuses here if needed
			pass
	
	return final_damage
