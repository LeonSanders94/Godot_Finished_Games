extends Area2D

var spd = 50
var scrapy = true
var collected = false
var being_pulled = false
@onready var player: CharacterBody2D = %Player

# Timer replacement (ONLY change)
var lifetime_timer: float = 0.0

func _physics_process(delta):
	# Timer update (ONLY change)
	lifetime_timer += delta
	
	if being_pulled:
		var player = get_tree().get_first_node_in_group("Playergroup")
		if player:
			var direction = (player.global_position - global_position).normalized()
			position += direction * abs(spd) * delta  # Use abs() to ensure correct direction
	else:
		position += Vector2(0, abs(spd)) * delta  # Simple downward fall
		
		# Cleanup (replaces _process timer hell)
	if RedFleet.EOW == true or lifetime_timer >= 15.0:
		queue_free()

func _on_body_entered(body):
	if collected:
		return
		
	if body.has_method("increase_money"):
		collected = true
		
		# Calculate final money with all bonuses
		var base_money = 5 + (Player.Wave * 2)
		var final_money = calculate_final_scrap_money(base_money)
		
		# Apply money directly
		Player.money += final_money
		Player.report.Total_Money_Collected += final_money
		print("Collected ", final_money, " money (", base_money, " base + bonuses)")
		
		hide()
		set_physics_process(false)
		set_monitoring(false)
		await get_tree().create_timer(0.2).timeout
		queue_free()

func calculate_final_scrap_money(base_money: int) -> int:
	var final_money = base_money
	
	# FIXED: Use direct property access instead of has() method
	# Apply Better Scavenging (+1 per scrap)
	if "scrap_money_bonus" in Player and Player.scrap_money_bonus > 0:
		final_money += Player.scrap_money_bonus
		print("Better Scavenging: +", Player.scrap_money_bonus, " money")
	
	# Apply Lucky Charm (+10% money from scrap)  
	if "scrap_money_multiplier" in Player and Player.scrap_money_multiplier > 1.0:
		final_money = int(final_money * Player.scrap_money_multiplier)
		print("Lucky Charm: x", Player.scrap_money_multiplier, " multiplier")
	
	# Apply enemy-specific money bonuses (if this scrap came from a specific enemy)
	if has_meta("enemy_type"):
		var enemy_type = get_meta("enemy_type")
		match enemy_type:
			"fighter":
				if "fighter_money_bonus" in Player and Player.fighter_money_bonus > 0:
					final_money += Player.fighter_money_bonus
					print("Fighter bonus: +", Player.fighter_money_bonus, " money")
			"bomber":
				if "bomber_money_bonus" in Player and Player.bomber_money_bonus > 0:
					final_money += Player.bomber_money_bonus
					print("Bomber bonus: +", Player.bomber_money_bonus, " money")
	
	return final_money

func pullable():
	being_pulled = true
