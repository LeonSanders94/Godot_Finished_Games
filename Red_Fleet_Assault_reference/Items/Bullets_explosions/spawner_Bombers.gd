extends Marker2D

@onready var level_1: Node2D = $"../../.."
@onready var spawn_cooldown: Timer = $spawn_cooldown

@export var fighter: PackedScene
@export var bomber: PackedScene
@export var carrier: PackedScene

# Constants for bomber limits per wave
const BOMBER_LIMITS = {
	1: 0,
	2: 2,
	3: 3,
	4: 4,
	5: 4,
	6: 5,
	7: 5,
	8: 6,
	9: 6,
	10: 7
}

# Spawn decision constants
const SPAWN_CHANCE_RANGE = 9
const MIN_WAVE_FOR_BOMBERS = 2
const MIN_WAVE_FOR_CARRIERS = 10
const MAX_CARRIERS = 2

# Cached values
var current_wave: int = -1  # Track when to update bomber limit
var bomber_limit: int = 0

func _ready():
	# Connect the spawn cooldown signal if it exists
	# (Assuming you have a Timer node with this signal)
	var spawn_timer = get_node_or_null("SpawnCooldown")
	if spawn_timer and spawn_timer.has_signal("timeout"):
		spawn_timer.timeout.connect(_on_spawn_cooldown_timeout)
	
	update_wave_settings()

func _process(_delta: float):
	# Only update when wave changes (much more efficient)
	if Player.Wave != current_wave:
		update_wave_settings()

func update_wave_settings():
	current_wave = Player.Wave
	bomber_limit = get_bomber_limit_for_wave(current_wave)
	print("Wave %d: Bomber limit set to %d" % [current_wave, bomber_limit])

func get_bomber_limit_for_wave(wave_num: int) -> int:
	if wave_num in BOMBER_LIMITS:
		return BOMBER_LIMITS[wave_num]
	elif wave_num > 10:
		# For waves above 10, increase by 2 from wave 10 base
		return BOMBER_LIMITS[10] + ((wave_num - 10) * 2)
	else:
		return 0

func spawn_bomber():
	if not bomber:
		push_warning("Bomber scene not assigned!")
		return
	
	# Random chance to spawn bomber vs other enemies
	var spawn_type = randi() % 2
	
	if spawn_type == 0:
		var new_bomber = bomber.instantiate()
		add_child(new_bomber)
		new_bomber.global_position = global_position
		print("Bomber spawned at wave %d" % current_wave)

func spawn_carrier():
	if not carrier:
		push_warning("Carrier scene not assigned!")
		return
	
	print("Spawning carrier at wave %d" % current_wave)
	var new_carrier = carrier.instantiate()
	add_child(new_carrier)
	new_carrier.global_position = global_position

func spawn_fighter():
	if not fighter:
		push_warning("Fighter scene not assigned!")
		return
	
	var new_fighter = fighter.instantiate()
	add_child(new_fighter)
	new_fighter.global_position = global_position
	print("Fighter spawned at wave %d" % current_wave)

func _on_spawn_cooldown_timeout() -> void:
	if Debug.debug_enabled:
		Debug.start_timer("spawner_bombers")
	
	spawn_cooldown.wait_time = randf()
	check_carrier_spawn()
	check_enemy_spawn()
	if Debug.debug_enabled:
		Debug.end_timer("spawner_bombers")

func check_carrier_spawn():
	# Only spawn carriers on wave 10+ and if under limit
	if current_wave >= MIN_WAVE_FOR_CARRIERS and Player.Carrier_count <= MAX_CARRIERS:
		Player.Carrier_count -= 1  # Decrease available carrier count
		spawn_carrier()

func check_enemy_spawn():
	# Spawn decision logic
	var spawn_decision = randi() % SPAWN_CHANCE_RANGE
	
	# Check if we should spawn bombers
	if should_spawn_bomber():
		spawn_bomber()
	elif should_spawn_fighter():
		spawn_fighter()
	# Add more enemy types here as needed

func should_spawn_bomber() -> bool:
	return (current_wave >= MIN_WAVE_FOR_BOMBERS and 
			RedFleet.bomber_count < bomber_limit)

func should_spawn_fighter() -> bool:
	# Add your fighter spawn conditions here
	# For now, spawn fighters when bombers are at limit
	return RedFleet.bomber_count >= bomber_limit

# Debug function for testing
func debug_spawner_info():
	print("=== SPAWNER DEBUG ===")
	print("Current Wave: %d" % current_wave)
	print("Bomber Limit: %d" % bomber_limit)
	print("Current Bomber Count: %d" % RedFleet.bomber_count)
	print("Carrier Count: %d" % Player.Carrier_count)
	print("Should spawn bombers: %s" % should_spawn_bomber())
	print("Should spawn fighters: %s" % should_spawn_fighter())
