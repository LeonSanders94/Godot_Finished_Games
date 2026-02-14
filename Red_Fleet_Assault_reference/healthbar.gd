extends ProgressBar

@onready var shield_bar: ProgressBar = $shieldbar
@onready var health_bar: ProgressBar = $"."
@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer
@onready var shield_damage_bar: ProgressBar = $shieldbar/sDamagebar
@onready var hp_current_label: Label = $HP_current
@onready var hp_total_label: Label = $Hp_total

# Cache maximum values (only update when they actually change)
var max_health: float
var max_shield: float

# Current values with setters
var health: float : set = set_health
var shield: float : set = set_shield

# Previous values to track changes efficiently
var previous_health: float = -1
var previous_shield: float = -1
var previous_max_health: float = -1
var previous_max_shield: float = -1

func _ready():
	# Initialize values
	max_health = Player.Player_Attributes.player_hp_total
	max_shield = Player.Player_Attributes.player_shield_max
	
	# Set initial values
	health = Player.Player_Attributes.player_current_HP
	shield = Player.Player_Attributes.player_shield_current
	
	# Connect timer signal
	if timer:
		timer.timeout.connect(_on_timer_timeout)
	
	# Initialize UI
	init_health_display()
	init_shield_display()

func _process(_delta: float):
	# Only update when values actually change (much more efficient)
	update_health_if_changed()
	update_shield_if_changed()
	update_max_values_if_changed()
	update_labels()

func update_health_if_changed():
	var current_health = Player.Player_Attributes.player_current_HP
	if current_health != previous_health:
		health = current_health
		previous_health = current_health

func update_shield_if_changed():
	var current_shield = Player.Player_Attributes.player_shield_current
	if current_shield != previous_shield:
		shield = current_shield
		previous_shield = current_shield

func update_max_values_if_changed():
	var current_max_health = Player.Player_Attributes.player_hp_total
	var current_max_shield = Player.Player_Attributes.player_shield_max
	
	if current_max_health != previous_max_health:
		max_health = current_max_health
		health_bar.max_value = max_health
		damage_bar.max_value = max_health
		previous_max_health = current_max_health
	
	if current_max_shield != previous_max_shield:
		max_shield = current_max_shield
		shield_bar.max_value = max_shield
		shield_damage_bar.max_value = max_shield
		previous_max_shield = current_max_shield

func update_labels():
	hp_current_label.text = "%.0f" % health
	hp_total_label.text = "/%.0f" % max_health

func set_health(new_health: float):
	var old_health = health
	health = clamp(new_health, 0, max_health)
	
	# Update health bar
	health_bar.value = health
	
	# Handle death
	if health <= 0:
		handle_death()
		return
	
	# Handle damage (start timer for damage bar animation)
	if health < old_health and old_health > 0:
		if timer:
			timer.start()
	else:
		# Healing - immediately update damage bar
		damage_bar.value = health

func set_shield(new_shield: float):
	var old_shield = shield
	shield = clamp(new_shield, 0, max_shield)
	
	# Update shield bar
	shield_bar.value = shield
	
	# Show/hide shield bar based on shield amount
	if shield > 0:
		shield_bar.show()
	else:
		shield_bar.hide()
	
	# Handle shield damage (start timer for damage bar animation)
	if shield < old_shield and old_shield > 0:
		if timer:
			timer.start()
	else:
		# Shield restoration - immediately update damage bar
		shield_damage_bar.value = shield

func init_health_display():
	health_bar.max_value = max_health
	health_bar.value = health
	damage_bar.max_value = max_health
	damage_bar.value = health

func init_shield_display():
	shield_bar.max_value = max_shield
	shield_bar.value = shield
	shield_damage_bar.max_value = max_shield
	shield_damage_bar.value = shield
	
	# Initial visibility
	if shield > 0:
		shield_bar.show()
	else:
		shield_bar.hide()

func handle_death():
	# Handle player death logic here
	print("Player died!")
	# Don't queue_free() the UI - let the game manager handle death

func _on_timer_timeout() -> void:
	# Animate damage bars to current values
	damage_bar.value = health
	shield_damage_bar.value = shield

# Public functions for external initialization
func initialize_health(initial_health: float):
	max_health = Player.Player_Attributes.player_hp_total
	health = initial_health
	init_health_display()

func initialize_shield(initial_shield: float):
	max_shield = Player.Player_Attributes.player_shield_max
	shield = initial_shield
	init_shield_display()

# Utility functions for testing/debugging
func debug_health_info():
	print("=== HEALTH BAR DEBUG ===")
	print("Health: %.0f/%.0f" % [health, max_health])
	print("Shield: %.0f/%.0f" % [shield, max_shield])
	print("Health Bar Value: %.0f" % health_bar.value)
	print("Shield Bar Value: %.0f" % shield_bar.value)
