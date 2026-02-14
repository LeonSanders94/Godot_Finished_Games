# UIManager.gd
# Save this file as UIManager.gd in your project root
extends Node

# Cache previous values to detect changes
var previous_values = {
	"money": -1,
	"wave": -1,
	"health": -1,
	"max_health": -1,
	"shield": -1,
	"max_shield": -1,
	"score": -1,
	"repair_kits": -1
}

# Store references to UI elements that need updates
var ui_elements = {}

func _ready():
	print("UIManager initialized")

func register_ui_element(element_name: String, ui_node: Node, update_function: String):
	"""Register a UI element for automatic updates"""
	if not ui_elements.has(element_name):
		ui_elements[element_name] = []
	
	ui_elements[element_name].append({
		"node": ui_node,
		"function": update_function
	})
	
	print("Registered UI element: ", element_name, " -> ", ui_node.name)

func _process(_delta: float):
	# Only check for changes, not update everything
	check_and_update_money()
	check_and_update_wave()
	check_and_update_health()
	check_and_update_score()
	check_and_update_repair_kits()

func check_and_update_money():
	if Player.money != previous_values.money:
		previous_values.money = Player.money
		update_ui_elements("money", Player.money)

func check_and_update_wave():
	if Player.Wave != previous_values.wave:
		previous_values.wave = Player.Wave
		update_ui_elements("wave", Player.Wave)

func check_and_update_health():
	var current_hp = Player.Player_Attributes.player_current_HP
	var max_hp = Player.Player_Attributes.player_hp_total
	
	if current_hp != previous_values.health or max_hp != previous_values.max_health:
		previous_values.health = current_hp
		previous_values.max_health = max_hp
		update_ui_elements("health", {"current": current_hp, "max": max_hp})

func check_and_update_score():
	if Player.Player_Attributes.player_score != previous_values.score:
		previous_values.score = Player.Player_Attributes.player_score
		update_ui_elements("score", Player.Player_Attributes.player_score)

func check_and_update_repair_kits():
	if Player.Player_Stats.repair_kits != previous_values.repair_kits:
		previous_values.repair_kits = Player.Player_Stats.repair_kits
		update_ui_elements("repair_kits", Player.Player_Stats.repair_kits)

func update_ui_elements(element_type: String, value):
	"""Update all registered UI elements of a specific type"""
	if ui_elements.has(element_type):
		for element_data in ui_elements[element_type]:
			var node = element_data.node
			var function_name = element_data.function
			
			if is_instance_valid(node) and node.has_method(function_name):
				node.call(function_name, value)

# Utility function for immediate updates (useful for shop, etc.)
func force_update_all():
	"""Force update all UI elements immediately"""
	previous_values.money = -1
	previous_values.wave = -1
	previous_values.health = -1
	previous_values.score = -1
	previous_values.repair_kits = -1
