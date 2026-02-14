extends Control

var shop = Shop
var item_slots = [{}, {}, {}]  # Array to hold all three item picks
var items_com = Shop.items_com
var items_uncom = Shop.items_uncom
var items_rare = Shop.items_rares
var items_exceptional = Shop.items_exceptional
var upg_chk_shield = 0
var upg_chk_health = 0
var upg_chk_dmg = 0
var upg_chk_spd = 0
var upg_chk_rof = 0
var upg_chk_raii = 0
var upg_chk_chaos = 0
var upg_chk_mag = 0 
var item_purchased = [false, false, false]  # Track purchased state for each slot
var prices = [0, 0, 0]  # Prices for each slot
var reroll_cost = 0
var base_reroll_cost = 20
var rerolls_used = 0
var End_wave = false
@onready var not_enoough: Label = $Buttons/reroll/Not_Enoough

# Add this to your existing shop script

# Dictionary to store item effects for tooltips
var item_effects = {
	# COMMON ITEMS
	"Advanced Blaster": {
		"positive": ["Damage +1", "Fire Rate +1"],
		"negative": []
	},
	"Targeting Computer": {
		"positive": ["Fire Rate +1"],
		"negative": []
	},
	"Extra Batteries": {
		"positive": ["Shield +1"],
		"negative": []
	},
	"Spring Cleaning": {
		"positive": ["Repair Kits +1"],
		"negative": []
	},
	"A Few Sticks Of RAM": {
		"positive": ["Robo AI Integrations +1"],
		"negative": []
	},
	"Mini Bot": {
		"positive": ["Robo AI Integrations +1"],
		"negative": []
	},
	"Heal Bot": {
		"positive": ["Robomechanic +1"],
		"negative": []
	},
	"Heavy Blaster": {
		"positive": ["Damage +2"],
		"negative": ["Fire Rate -1"]
	},
	"Turbo Boosters": {
		"positive": ["Speed +1"],
		"negative": ["Armor -1"]
	},
	"Nanomachines": {
		"positive": ["Life Steal +1"],
		"negative": ["Fire Rate -1"]
	},
	"Red Baron Kit": {
		"positive": ["Maneuvering +1"],
		"negative": []
	},
	"Shield Bot": {
		"positive": ["Shield +1"],
		"negative": []
	},
	"Health +": {
		"positive": ["Health +1"],
		"negative": []
	},
	"Reinforced Hull": {
		"positive": ["Health +1"],
		"negative": []
	},
	"Recycled Metal": {
		"positive": ["Armor +1"],
		"negative": []
	},
	"Extra Stuffing": {
		"positive": ["Armor +1"],
		"negative": []
	},
	"Deflector Plates": {
		"positive": ["Armor +2"],
		"negative": []
	},
	"Overclock Module": {
		"positive": ["Fire Rate +1", "Damage +2"],
		"negative": []
	},
	"Vampire Plasma": {
		"positive": ["Life Steal +1"],
		"negative": []
	},
	"Mr. Fix It": {
		"positive": ["Robomechanic +1"],
		"negative": []
	},
	"Lightweight Frame": {
		"positive": ["Speed +1"],
		"negative": ["Armor -1"]
	},
	"Space Dust Extract": {
		"positive": ["Speed +2"],
		"negative": ["Maneuvering -1"]
	},
	"Power Capacitor": {
		"positive": ["Damage +1"],
		"negative": ["Shield -1"]
	},
	"Rapid Loader": {
		"positive": ["Fire Rate +1"],
		"negative": ["Damage -1"]
	},
	"Precision Targeting": {
		"positive": ["Damage +1"],
		"negative": ["Fire Rate -1"]
	},
	"Glass Cannon": {
		"positive": ["Damage +1"],
		"negative": ["Fire Rate -1"]
	},
	"Overcharge Capacitor": {
		"positive": ["Damage +2", "Fire Rate +1"],
		"negative": []
	},
	"Lucky Charm": {
		"positive": ["Luck System"],
		"negative": []
	},
	"Better Scavenging": {
		"positive": ["Better Scrap Drops"],
		"negative": []
	},
	"Fighter money increase": {
		"positive": ["Fighter Money Bonus"],
		"negative": ["Fighter Damage Reduction"]
	},
	"Bang for your Buck": {
		"positive": ["Bomber Money Bonus"],
		"negative": ["Bomber Damage Reduction"]
	},
	"Heal kit": {
		"positive": ["Robomechanic +1"],
		"negative": []
	},
	"Know The Enemy": {
		"positive": ["Enemy Health Display"],
		"negative": []
	},
	"Pilot's Instinct": {
		"positive": ["Maneuvering +1"],
		"negative": []
	},
	"Afterburner": {
		"positive": ["Maneuvering +1", "Speed +1"],
		"negative": ["Armor -1"]
	},
	"Evasion Protocol": {
		"positive": ["Maneuvering +1"],
		"negative": []
	},
	"Heavy Plating": {
		"positive": ["Armor +1"],
		"negative": []
	},
	
	# UNCOMMON ITEMS
	"Magnet": {
		"positive": ["Magnet Ability", "Mag Size +1"],
		"negative": []
	},
	"Titanium Carbon Steel Reinforcement": {
		"positive": ["Health +1", "Armor +1"],
		"negative": ["Speed -1", "Fire Rate -1"]
	},
	"Sun juice": {
		"positive": ["Damage +2"],
		"negative": ["Armor -1"]
	},
	"Plate up": {
		"positive": ["Armor +2"],
		"negative": ["Speed -1"]
	},
	"Bulwark": {
		"positive": ["Armor +2"],
		"negative": ["Health -1"]
	},
	"Health ++": {
		"positive": ["Health +2"],
		"negative": ["Armor -1"]
	},
	"Repair Pack": {
		"positive": ["Repair Kits +3"],
		"negative": []
	},
	"Missile": {
		"positive": ["Missile System"],
		"negative": []
	},
	"Void Bomb": {
		"positive": ["Void Bomb Ability"],
		"negative": []
	},
	"Kill Counter": {
		"positive": ["Kill-Based Bonuses"],
		"negative": []
	},
	"Survivor's Resolve": {
		"positive": ["Low Health Bonuses"],
		"negative": []
	},
	
	# RARE ITEMS
	"Gel Impact": {
		"positive": ["Health +1"],
		"negative": []
	},
	"Friendly Memory Core Processing Unit Update": {
		"positive": ["Robo AI Integrations +2"],
		"negative": ["Damage -1"]
	},
	"Hyper Turbo Boosters": {
		"positive": ["Speed +3"],
		"negative": ["Health -1", "Armor -1"]
	},
	"Wormhole Drive": {
		"positive": ["Teleportation Ability"],
		"negative": ["No Mini Bots"]
	},
	"Charge Bolts": {
		"positive": ["Charging System"],
		"negative": ["No Chaotic Substance"]
	},
	
	# EXCEPTIONAL ITEMS
	"Auto Blaster": {
		"positive": ["Fire Rate +3", "Damage +1"],
		"negative": ["Health -2"]
	},
	"Unknown Chaotic Substance": {
		"positive": ["Extra Bullets +1"],
		"negative": ["Damage Halved"]
	}
}

# Function to generate tooltip text for an item
func get_item_tooltip(item_name: String) -> String:
	if not item_effects.has(item_name):
		return "No information available"
	
	var effects = item_effects[item_name]
	var tooltip_text = ""
	
	# Add positive effects
	if effects.has("positive") and effects["positive"].size() > 0:
		tooltip_text += "Benefits:\n"
		for effect in effects["positive"]:
			tooltip_text += "• " + str(effect) + "\n"
	
	# Add negative effects
	if effects.has("negative") and effects["negative"].size() > 0:
		if tooltip_text != "":
			tooltip_text += "\n"
		tooltip_text += "Drawbacks:\n"
		for effect in effects["negative"]:
			tooltip_text += "• " + str(effect) + "\n"
	
	if tooltip_text == "":
		return "This item has no documented effects"
	
	return tooltip_text.strip_edges()

# Modified generate_item_for_slot function to include tooltip
func generate_item_for_slot(slot_index: int):
	var rarity_roll = randi() % 100
	var item_pool = []
	
	# Determine rarity and item pool
	if rarity_roll <= 69:  # 70% (0-69)
		item_pool = items_com
	elif rarity_roll <= 89:  # 20% (70-89)
		item_pool = items_uncom
	elif rarity_roll <= 96:  # 7% (90-96)
		item_pool = items_rare
	else:  # 3% (97-99)
		item_pool = items_exceptional
	
	# Select random item from pool
	var item_index = randi() % item_pool.size()
	item_slots[slot_index] = item_pool[item_index]
	
	# Update UI
	var button_path = "Buttons/Item_%d" % (slot_index + 1)
	var button = get_node(button_path)
	button.set_button_icon(item_slots[slot_index].icon)
	button.set_text(item_slots[slot_index]["Name"])
	
	# Set tooltip
	var tooltip_text = get_item_tooltip(item_slots[slot_index]["Name"])
	button.tooltip_text = tooltip_text
	
	print("Generated item for slot %d: %s" % [slot_index + 1, item_slots[slot_index]["Name"]])

# Alternative method if you want custom tooltip display
# Add these functions if you want more control over tooltip appearance

var tooltip_panel: Panel
var tooltip_label: RichTextLabel

func _ready():
	# Create custom tooltip (optional - only if you want custom styling)
	create_custom_tooltip()

func create_custom_tooltip():
	# Create tooltip panel
	tooltip_panel = Panel.new()
	tooltip_panel.visible = false
	tooltip_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tooltip_panel)
	
	# Create tooltip label
	tooltip_label = RichTextLabel.new()
	tooltip_label.bbcode_enabled = true
	tooltip_label.fit_content = true
	tooltip_panel.add_child(tooltip_label)
	
	# Style the tooltip panel
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.1, 0.9)
	style_box.border_width_top = 2
	style_box.border_width_bottom = 2
	style_box.border_width_left = 2
	style_box.border_width_right = 2
	style_box.border_color = Color(0.6, 0.6, 0.6)
	style_box.corner_radius_top_left = 5
	style_box.corner_radius_top_right = 5
	style_box.corner_radius_bottom_left = 5
	style_box.corner_radius_bottom_right = 5
	tooltip_panel.add_theme_stylebox_override("panel", style_box)

func hide_custom_tooltip():
	if tooltip_panel:
		tooltip_panel.visible = false


func _on_item_button_mouse_exited():
	hide_custom_tooltip()

# Item removal functions for each slot
func remove_item(slot_index: int):
	item_slots[slot_index] = shop.empty_slot
	item_purchased[slot_index] = false
	var button_path = "Buttons/Item_%d" % (slot_index + 1)
	get_node(button_path).set_button_icon(item_slots[slot_index].icon)
	get_node(button_path).set_text(item_slots[slot_index]["Name"])
	item_slots[slot_index].rarity = 'none'
	
	prices[slot_index] = 0
	var price_label_path = "Buttons/Item_%d/price_%d" % [slot_index + 1, slot_index + 1]
	get_node(price_label_path).text = "0"
	
	
# Unified purchase function
func try_buy_item(slot_index: int):
	if Player.money >= prices[slot_index]:
		Player.money -= prices[slot_index]
		item_purchased[slot_index] = true
		await get_tree().create_timer(0.3)
		apply_item_effects(item_slots[slot_index])
		remove_item(slot_index)
	else:
		print("Not enough money!")
		not_enoough.show()
		print('not_enought_timer_start')
	
		var tween = create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)  # Continue during pause
		tween.tween_callback(func(): not_enoough.hide()).set_delay(1.0)

# Apply item effects to player stats
func apply_item_effects(item: Dictionary):
	var item_name = item["Name"]
	print("Applying item: ", item_name)
	
	match item_name:
		# === COMMON ITEMS (items_com) ===
		
		# Pure Positive Items
		"Advanced Blaster":
			Player.Player_Stats.damage += 1
			Player.Player_Stats.fire_rate += 1
		"Targeting Computer", "Overclock Module":
			Player.Player_Stats.fire_rate += 1
		"Extra Batteries":
			Player.Player_Stats.shield += 1
		"Spring Cleaning":
			Player.Player_Stats.repair_kits += 1
		"A Few Sticks Of RAM":
			Player.Player_Stats.robo_ai_integrations += 1
		"Mini Bot":
			Player.Player_Stats.robo_ai_integrations += 1  # Note: pos_1 = "aimbot_1" in data
		"Heal Bot", "Mr. Fix It", "Heal kit":
			Player.Player_Stats.robomechanic += 1
		"Red Baron Kit", "Pilot's Instinct", "Evasion Protocol":
			Player.Player_Stats.maneuvering += 1
		"Health +", "Reinforced Hull":
			Player.Player_Stats.health += 1
		"Recycled Metal", "Extra Stuffing", "Heavy Plating":
			Player.Player_Stats.armor += 1
		"Deflector Plates":
			Player.Player_Stats.armor += 2
		"Vampire Plasma":
			Player.Player_Stats.life_steal += 1
		"Overcharge Capacitor":
			Player.Player_Stats.damage += 2
			Player.Player_Stats.fire_rate += 1
			
		# Trade-off Items (Positive + Negative)
		"Heavy Blaster":
			Player.Player_Stats.damage += 2
			Player.Player_Stats.fire_rate -= 1
		"Turbo Boosters", "Lightweight Frame":
			Player.Player_Stats.speed += 1
			Player.Player_Stats.armor -= 1
		"Nanomachines":
			Player.Player_Stats.life_steal += 1
			Player.Player_Stats.fire_rate -= 1
		"Space Dust Extract":
			Player.Player_Stats.speed += 2
			Player.Player_Stats.maneuvering -= 1
		"Power Capacitor":
			Player.Player_Stats.damage += 1
			Player.Player_Stats.shield -= 1
		"Rapid Loader":
			Player.Player_Stats.fire_rate += 1
			Player.Player_Stats.damage -= 1
		"Precision Targeting", "Glass Cannon":
			Player.Player_Stats.damage += 1
			Player.Player_Stats.fire_rate -= 1
		"Afterburner":
			Player.Player_Stats.maneuvering += 1
			Player.Player_Stats.speed += 1
			Player.Player_Stats.armor -= 1
			
		# Special Mechanics (Common)
		"Lucky Charm":
			print("Lucky Charm - TODO: Implement luck system")
		"Better Scavenging":
			print("Better Scavenging - TODO: Implement scrap bonus")
		"Fighter money increase":
			print("Fighter money increase - TODO: Implement fighter bonuses")
		"Bang for your Buck":
			print("Bang for your Buck - TODO: Implement bomber bonuses")
		"Know The Enemy":
			print("Know The Enemy - TODO: Implement enemy health display")
			
		# Broken Item (needs fix in item data)
		"Shield Bot":
			# Note: In your data this is pos_1 = Player.Player_Stats.shield - 1 (decreases shield!)
			# This should probably be +1, but applying as defined:
			Player.Player_Stats.shield -= 1
			print("WARNING: Shield Bot decreases shield! Check item definition.")
			
		# === UNCOMMON ITEMS (items_uncom) ===
		"Magnet":
			Player.Player_Attributes.magnet = true
			Player.Player_Stats.mag_size += 1
		"Titanium Carbon Steel Reinforcement":
			Player.Player_Stats.health += 1
			Player.Player_Stats.armor += 1
			Player.Player_Stats.speed -= 1
			Player.Player_Stats.fire_rate -= 1
		"Sun juice":
			Player.Player_Stats.damage += 2
			Player.Player_Stats.armor -= 1
		"Plate up":
			Player.Player_Stats.armor += 2
			Player.Player_Stats.speed -= 1
		"Bulwark":
			Player.Player_Stats.armor += 2
			Player.Player_Stats.health -= 1
		"Health ++":
			Player.Player_Stats.health += 2
			Player.Player_Stats.armor -= 1
		"Repair Pack":
			Player.Player_Stats.repair_kits += 3
			
		# Special Mechanics (Uncommon)
		"Survivor's Resolve":
			Player.special_items["survivors_resolve"] = true
			Player.survivors_resolve_stacks = 1
			print("Survivor's Resolve acquired! Damage +50% when below 50% health")
		"Kill Counter":
			Player.special_items["kill_counter"] = true
			Player.kill_counter_stacks = 0  # Starts at 0, builds with kills
			print("Kill Counter acquired! Damage increases with kills")
		"Lucky Charm":
			Player.special_items["lucky_charm"] = true
			print("Lucky Charm acquired! (TODO: Implement luck mechanics)")
		
		"Better Scavenging":
			Player.special_items["better_scavenging"] = true
			print("Better Scavenging acquired! (TODO: Implement scrap bonuses)")
		
		"Know The Enemy":
			Player.special_items["know_enemy"] = true
			print("Know The Enemy acquired! (TODO: Show enemy health bars)")



		"Missile", "Void Bomb", "Kill Counter", "Survivor's Resolve":
			print(item_name, " - TODO: Implement special mechanic")
			
		# === RARE ITEMS (items_rares) ===
		"Gel Impact":
			Player.Player_Stats.health += 1
		"Friendly Memory Core Processing Unit Update":
			Player.Player_Stats.robo_ai_integrations += 2
			Player.Player_Stats.damage -= 1
		"Hyper Turbo Boosters":
			Player.Player_Stats.speed += 3
			Player.Player_Stats.health -= 1
			Player.Player_Stats.armor -= 1
			
		# Special Mechanics (Rare)
		"Wormhole Drive":
			print("Wormhole Drive - TODO: Implement teleportation")
		"Charge Bolts":
			print("Charge Bolts - TODO: Implement charging system")
			
		# === EXCEPTIONAL ITEMS (items_exceptional) ===
		"Auto Blaster":
			Player.Player_Stats.fire_rate += 3
			Player.Player_Stats.damage += 1
			Player.Player_Stats.health -= 2
		"Unknown Chaotic Substance":
			Player.chaos += 1
			print("Chaos substance applied - damage halving handled in player_char_update()")
			
		
		# === SPECIAL MECHANICS (Correct implementations) ===
		"Fighter money increase":
			handle_fighter_money_increase()
		"Bang for your Buck":
			handle_bang_for_your_buck()
		"Know The Enemy":
			handle_know_the_enemy()
		"Better Scavenging":
			handle_better_scavenging()
		"Lucky Charm":
			handle_lucky_charm()
		"Reinforced Hull":
			handle_reinforced_hull()
		"Missile":
			handle_missile()
		"Void Bomb":
			handle_void_bomb()
		"Kill Counter":
			handle_kill_counter()
		"Survivor's Resolve":
			handle_survivors_resolve()
		"Wormhole Drive":
			handle_wormhole_drive()
		"Charge Bolts":
			handle_charge_bolts()

		# === FALLBACK ===
		_:
			print("WARNING: Unknown item '", item_name, "' - no effects applied")
			print("Available items should be defined in Shop item data (document 63)")

func _on_next_round_pressed() -> void:
	hide()
	%Wave_status.show()
	$"../Wave_status/Wave_number".show()
	await get_tree().create_timer(2.0).timeout
	%Wave_Timer.start()
	RedFleet.EOW = false
	$"../Wave_status/Wave_number".hide()
	%Wave_status.hide()
	get_tree().paused = false
	Levels.paused = false
	player_char_update()
	print('Stats:', Player.Player_Stats, 'Attributes:', Player.Player_Attributes)

func _on_wave_timer_timeout() -> void:
	%Wave_Timer.stop()
	if %Player.is_dying == false and Player.wave_delay == 0:
		RedFleet.EOW = true
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = true
		%Wave_status.show()
		$"../Wave_status/Eow".show()
		await get_tree().create_timer(2.0).timeout
		%Wave_status.hide()
		$"../Wave_status/Eow".hide()
		show()
		Levels.paused = true
	else:
		return

	# Generate items for all three slots
	for i in range(3):
		generate_item_for_slot(i)
	
	update_prices()
	update_reroll_button()  

func update_prices():
	for i in range(3):
		var item = item_slots[i]
		var price_label_path = "Buttons/Item_%d/price_%d" % [i + 1, i + 1]
		
		match item.rarity:
			'none':
				prices[i] = 0
			"common":
				prices[i] = 50 * Player.Wave / 2
			"uncommon":
				prices[i] = 100 * Player.Wave / 2
			"rare":
				prices[i] = 150 * Player.Wave / 2
			"exceptional":
				prices[i] = 200 * Player.Wave / 2
		
		get_node(price_label_path).text = str(prices[i])

# Button handlers
func _on_item_1_button_up() -> void:
	try_buy_item(0)
	if item_purchased[0]:
		print('Button up_1!')
		print('You got:', item_slots[0])
		UiManager.update_money_display(Player.money)
		
func _on_item_2_button_up() -> void:
	try_buy_item(1)
	if item_purchased[1]:
		print('Button up_2!')
		print('You got:', item_slots[1])
		UiManager.update_money_display(Player.money)
		
func _on_item_3_button_up() -> void:
	try_buy_item(2)
	if item_purchased[2]:
		print('Button up_3!')
		print('You got:', item_slots[2])
		UiManager.update_money_display(Player.money)
func _on_reroll_button_up() -> void:
	var current_cost = get_current_reroll_cost()
	
	# Check money FIRST before doing anything
	if Player.money >= current_cost:
		Player.money -= current_cost
		
		# Only reroll if player has enough money
		for i in range(3):
			generate_item_for_slot(i)
		
		# Update reroll tracking AFTER successful purchase
		rerolls_used += 1
		reroll_cost += base_reroll_cost  # Increase by base cost each time
		
		update_prices()
		update_reroll_button()
	else:
		print("Not enough money to reroll! Need: ", current_cost, " Have: ", Player.money)
		not_enoough.show()
		
		var tween = create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_callback(func(): not_enoough.hide()).set_delay(1.0)
func get_current_reroll_cost() -> int:
	# Calculate the actual cost that will be charged
	# Base cost + accumulated reroll cost, scaled by wave
	return int((base_reroll_cost + reroll_cost) * Player.Wave / 2)


func update_reroll_button():
	# Show the CURRENT cost (what you'll pay right now)
	var current_cost = get_current_reroll_cost()
	var reroll_button = $Buttons/reroll/price_reroll
	reroll_button.text = str(current_cost)

func player_char_update():
	# Health updates
	if Player.Player_Stats.health > 0:
		var upgrade = Player.Player_Stats.health
		if upg_chk_health < upgrade:
			upg_chk_health = upgrade
			upgrade = (Player.Player_Stats.health * 10) + Player.Player_Attributes.player_hp_total
			Player.Player_Attributes.player_hp_total = upgrade

	else:
		Player.Player_Attributes.player_hp_total = 100
	
	# Shield updates
	if Player.Player_Stats.shield > 0:
		var upgrade = Player.Player_Stats.shield
		Player.Player_Attributes.player_shield_current = Player.Player_Attributes.player_shield_max
		if upg_chk_shield < upgrade:
			upg_chk_shield = upgrade
			upgrade = Player.Player_Stats.shield * 10
			Player.Player_Attributes.player_shield_max = upgrade
			Player.Player_Attributes.player_shield_current = Player.Player_Attributes.player_shield_max
			print(Player.Player_Attributes.player_shield_max)
	else:
		Player.Player_Attributes.player_shield_max = 0
		Player.Player_Attributes.player_shield_current = Player.Player_Attributes.player_shield_max
	
	# Damage updates
	if Player.Player_Stats.damage > 0:
		var upgrade = Player.Player_Stats.damage
		if upg_chk_dmg < upgrade:
			upg_chk_dmg = upgrade
			Player.Player_Attributes.player_weapon_dmg = upgrade + Powerups.weapons.basic.dmg
	else:
		Player.Player_Attributes.player_weapon_dmg = Powerups.weapons.basic.dmg
	
	# Speed updates
	if Player.Player_Stats.speed > 0:
		var upgrade = Player.Player_Stats.speed
		if upg_chk_spd < upgrade:
			upg_chk_spd = upgrade
			Player.speed_mod = -1 * (Player.Player_Stats.speed * 10)
		elif upg_chk_spd > upgrade:
			upg_chk_spd = upgrade
			Player.speed_mod = -1 * (Player.Player_Stats.speed * 10)
	else:
		Player.speed_mod = 0
	
	# Fire rate updates
	if Player.Player_Stats.fire_rate > 0:
		var upgrade = Player.Player_Stats.fire_rate
		if upg_chk_rof < upgrade:
			upg_chk_rof = upgrade
			Player.Player_Attributes.weapon_cooldown_max = Player.Player_Stats.fire_rate
	else:
		Player.Player_Attributes.weapon_cooldown_max = 2
	
	# Robomechanic updates
	if Player.Player_Stats.robomechanic > 0:
		#print("=== REGEN DEBUG START ===")
		#print("Robomechanic level: ", Player.Player_Stats.robomechanic)
		#print("Current upg_chk_health: ", upg_chk_health)
		#print("Current regen: ", Player.Player_Attributes.regen)
		
		var upgrade: float
		
		# Simplified calculation: 0.5 HP/sec per level
		upgrade = Player.Player_Stats.robomechanic * 0.5
		
	#	print("Simple calculation: ", Player.Player_Stats.robomechanic, " * 0.5 = ", upgrade, " HP/sec")
		#print("Will update? ", upg_chk_health < upgrade)
		
		if upg_chk_health < upgrade:
			upg_chk_health = upgrade
			Player.Player_Attributes.regen = upgrade
			print("✅ UPDATED! New regen: ", Player.Player_Attributes.regen, " HP/sec")
		else:
			print("❌ NO UPDATE - upg_chk_health (", upg_chk_health, ") >= upgrade (", upgrade, ")")
		
		#print("=== REGEN DEBUG END ===")
	else:
		print("Robomechanic = 0, setting regen to 0")
		Player.Player_Attributes.regen = 0
		
	# Robo AI integrations
	if Player.Player_Stats.robo_ai_integrations > 0:
		var upgrade = Player.Player_Stats.robo_ai_integrations
		if upg_chk_raii < upgrade:
			upg_chk_raii = upgrade
			Player.Player_Attributes.robos = Player.Player_Stats.robo_ai_integrations
	else:
		Player.Player_Attributes.robos = 0
	
	# Life steal updates
	if Player.Player_Stats.life_steal > 0:
		var upgrade = Player.Player_Stats.life_steal
		if upg_chk_health < upgrade:
			upg_chk_health = upgrade
			Player.Player_Attributes.leech = Player.Player_Stats.life_steal
	else:
		Player.Player_Attributes.leech = 0
	if Player.chaos > 0:
		var upgrade = Player.chaos
		if upg_chk_chaos < upgrade:
			upg_chk_chaos = upgrade
			Player.Player_Attributes.player_weapon_dmg += 0.5 * Player.Player_Stats.damage
	if Player.Player_Attributes.magnet == true:
		var upgrade = Player.Player_Stats.mag_size
		if upg_chk_mag < upgrade:
			upg_chk_mag = upgrade
	# Handle Reinforced Hull bonus health
func handle_reinforced_hull():
	# FIXED: Check if property exists using 'in' operator
	if not ("reinforced_hull_stacks" in Player):
		Player.reinforced_hull_stacks = 0
	if not ("reinforced_hull_bonus_applied" in Player):
		Player.reinforced_hull_bonus_applied = 0
		
	Player.reinforced_hull_stacks += 1
	
	# Recalculate bonus health whenever armor changes
	var current_bonus = (Player.Player_Stats.armor / 2) * Player.reinforced_hull_stacks
	var bonus_difference = current_bonus - Player.reinforced_hull_bonus_applied
	
	if bonus_difference != 0:
		Player.Player_Stats.health += bonus_difference
		Player.reinforced_hull_bonus_applied = current_bonus
		print("Reinforced Hull: Adjusted health by ", bonus_difference, " (total bonus: ", current_bonus, ")")

func handle_fighter_money_increase():
	# FIXED: Use 'in' operator instead of has()
	if not ("fighter_money_bonus" in Player):
		Player.fighter_money_bonus = 0
	if not ("fighter_damage_bonus" in Player):
		Player.fighter_damage_bonus = 0
		
	Player.fighter_money_bonus += 1  # More money from fighters
	Player.fighter_damage_bonus += 1  # +1 damage to fighters
	print("Fighter Money Increase: More money from fighters, +1 damage vs fighters")

func handle_bang_for_your_buck():
	# FIXED: Use 'in' operator instead of has()
	if not ("bomber_money_bonus" in Player):
		Player.bomber_money_bonus = 0
	if not ("bomber_damage_bonus" in Player):
		Player.bomber_damage_bonus = 0
		
	Player.bomber_money_bonus += 1  # More money from bombers
	Player.bomber_damage_bonus += 2  # +2 damage to bombers
	print("Bang for your Buck: More money from bombers, +2 damage vs bombers")

func handle_know_the_enemy():
	# FIXED: Use 'in' operator instead of has()
	if not ("fighter_damage_bonus" in Player):
		Player.fighter_damage_bonus = 0
	if not ("bomber_damage_bonus" in Player):
		Player.bomber_damage_bonus = 0
		
	Player.fighter_damage_bonus += 1  # +1 damage vs fighters
	Player.bomber_damage_bonus += 2   # +2 damage vs bombers
	print("Know The Enemy: +1 damage vs fighters, +2 damage vs bombers")

func handle_better_scavenging():
	# FIXED: Use 'in' operator instead of has()
	if not ("scrap_money_bonus" in Player):
		Player.scrap_money_bonus = 0
		
	Player.scrap_money_bonus += 1  # +1 extra money per scrap
	print("Better Scavenging: +1 extra money per scrap collected")

func handle_lucky_charm():
	# FIXED: Use 'in' operator instead of has()
	if not ("scrap_money_multiplier" in Player):
		Player.scrap_money_multiplier = 1.0
	Player.scrap_money_multiplier += 0.1  # +10% scrap money
	print("Lucky Charm: +10% money from scrap")

func handle_missile():
	# FIXED: Use direct dictionary access for Player_Attributes
	if not Player.Player_Attributes.has("missiles"):
		Player.Player_Attributes.missiles = 0
		
	Player.Player_Attributes.missiles += 1
	print("Missile: +1 missile (TODO: Implement missile weapon system)")

func handle_void_bomb():
	# FIXED: Use direct dictionary access for Player_Attributes  
	if not Player.Player_Attributes.has("void_bombs"):
		Player.Player_Attributes.void_bombs = 0
		
	Player.Player_Attributes.void_bombs += 1
	print("Void Bomb: +1 void bomb (TODO: Implement void bomb system)")

func handle_kill_counter():
	# FIXED: Use 'in' operator instead of has()
	if not ("kill_counter_stacks" in Player):
		Player.kill_counter_stacks = 0
	if not ("kill_counter_kills" in Player):
		Player.kill_counter_kills = 0
	if not ("kill_counter_timer" in Player):
		Player.kill_counter_timer = 0.0
	if not ("kill_counter_active" in Player):
		Player.kill_counter_active = false
		
	Player.kill_counter_stacks += 1
	Player.kill_counter_active = true
	print("Kill Counter: Damage scaling with kills (max ", Player.kill_counter_stacks * 5, " kills)")

func handle_survivors_resolve():
	# FIXED: Use 'in' operator instead of has()
	if not ("survivors_resolve_stacks" in Player):
		Player.survivors_resolve_stacks = 0
		
	Player.survivors_resolve_stacks += 1
	print("Survivor's Resolve: 1.5x damage when below 50% HP")

func handle_wormhole_drive():
	# FIXED: Use direct dictionary access for Player_Attributes
	if not Player.Player_Attributes.has("has_wormhole_dash"):
		Player.Player_Attributes.has_wormhole_dash = false
	Player.Player_Attributes.has_wormhole_dash = true
	
	# Disable mini bots as specified
	Player.Player_Attributes.robos = 0
	Player.Player_Stats.robo_ai_integrations = 0
	print("Wormhole Drive: Invulnerable dash enabled, mini bots disabled (TODO: Implement dash)")

func handle_charge_bolts():
	# FIXED: Use direct dictionary access for Player_Attributes
	if not Player.Player_Attributes.has("charge_bolt_stacks"):
		Player.Player_Attributes.charge_bolt_stacks = 0
	if not Player.Player_Attributes.has("charge_system_active"):
		Player.Player_Attributes.charge_system_active = false
		
	Player.Player_Attributes.charge_bolt_stacks += 1
	Player.Player_Attributes.charge_system_active = true
	
	# Disable Unknown Chaotic Substance as specified
	Player.chaos = 0
	print("Charge Bolts: Charge system active (", Player.Player_Attributes.charge_bolt_stacks,
		" stacks), chaos disabled (TODO: Implement)")
