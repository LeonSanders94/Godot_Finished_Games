extends Marker2D

@onready var level_1: Node2D = $"../../.."
@export var fighter: PackedScene
@export var mine: PackedScene  # Add mine scene
@export var bomber: PackedScene
@export var carrier: PackedScene

# Constants for clarity
const BASE_FIGHTER_LIMIT = 8
const FIGHTER_LIMIT_INCREASE = 2

# Variables (cleaner naming)
var spawn_memory: int
var fighter_limit: int = 0

# Cache wave values to avoid constant global access
var current_wave: int = 1
var current_carrier_count: int = 2

func _ready():
	# Initialize on startup
	update_wave_data()

func _process(delta):
	# Update wave data (but only when it actually changes)
	var new_wave = Player.Wave
	if new_wave != current_wave:
		current_wave = new_wave
		update_fighter_limit()
	
	# Update carrier count
	current_carrier_count = Player.Carrier_count

func update_wave_data():
	current_wave = Player.Wave
	current_carrier_count = Player.Carrier_count
	update_fighter_limit()

func update_fighter_limit():
	# Cleaner fighter limit calculation
	if current_wave == 1:
		fighter_limit = BASE_FIGHTER_LIMIT
	else:
		fighter_limit = BASE_FIGHTER_LIMIT + (current_wave - 1.5) * FIGHTER_LIMIT_INCREASE
	
	print("Wave ", current_wave, " - Fighter/Mine limit set to: ", fighter_limit)

# Updated spawn function to include mines
func spawn_fighter_or_mine():
	var spawn_roll = randf()
	
	if spawn_roll <= 0.8:
		# Spawn fighter 80% chance)
		return spawn_fighter()
	else:
		# Spawn mine (20% chance)
		return spawn_mine()

func spawn_fighter():
	if not fighter:
		print("Warning: Fighter scene not assigned!")
		return false
	
	# 50% chance to spawn (same as your existing logic)
	if randf() > 0.5:
		var spawn := fighter.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		print("Fighter spawned at: ", global_position)
		return true
	
	return false

func spawn_mine():
	if not mine:
		print("Warning: Mine scene not assigned!")
		return false
	
	# 50% chance to spawn (same logic as fighter)
	if randf() > 0.5:
		var spawn := mine.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		print("Mine spawned at: ", global_position)
		return true
	
	return false

func spawn_bomber():
	if not bomber:
		print("Warning: Bomber scene not assigned!")
		return false
	
	var spawn := bomber.instantiate()
	add_child(spawn)
	spawn.global_position = global_position
	print("Bomber spawned at: ", global_position)
	return true

func spawn_carrier():
	if not carrier:
		print("Warning: Carrier scene not assigned!")
		return false
	
	# Only spawn if conditions are met
	if current_carrier_count >= 0 and current_wave >= 10:
		var spawn := carrier.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		print("Carrier spawned at: ", global_position)
		return true
	
	return false

func _on_spawn_cooldown_timeout() -> void:
	if Debug.debug_enabled:
		Debug.start_timer("spawner_main")
	
	update_wave_data()  # Ensure fresh data
	carrier_check()
	fighter_mine_check()  # Updated function name
	if Debug.debug_enabled:
		Debug.end_timer("spawner_main")

func carrier_check():
	# Spawn carriers on wave 10+ with limit
	if current_wave >= 10 and current_carrier_count > 0:
		if spawn_carrier():
			Player.Carrier_count -= 1  # Decrease global count
			current_carrier_count = Player.Carrier_count

func fighter_mine_check():
	# Get current fighter count from global system
	# Note: Mines and fighters share the same spawn limit
	var current_fighter_count = RedFleet.fighter_count
	
	# Only spawn if under limit
	if current_wave >= 1 and current_fighter_count < fighter_limit:
		# Random spawn decision (same as your original logic)
		var spawn_decision = randi() % 9
		
		# Spawn fighter or mine with chance
		if spawn_decision <= 2:  # ~33% chance (adjust as needed)
			if spawn_fighter_or_mine():
				# Note: Fighter count is managed by the global RedFleet system
				# Mines might need their own counting system if needed
				pass
	
	# Debug info
	if current_fighter_count >= fighter_limit:
		print("Fighter/Mine limit reached: ", current_fighter_count, "/", fighter_limit)

# Additional utility functions for debugging
func get_spawn_info() -> Dictionary:
	return {
		"wave": current_wave,
		"fighter_limit": fighter_limit,
		"fighter_count": RedFleet.fighter_count,
		"carrier_count": current_carrier_count
	}

func debug_spawn_status():
	var info = get_spawn_info()
	print("=== SPAWN STATUS ===")
	for key in info:
		print(key, ": ", info[key])
