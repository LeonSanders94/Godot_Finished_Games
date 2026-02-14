extends Node2D

@export var planets: PackedScene
@export var asteroid: PackedScene  # Fixed typo: astroid → asteroid

@onready var planet_spawn_1: Marker2D = $PlanetSpawn_1
@onready var planet_spawn_2: Marker2D = $Planetspawn_2  # Fixed naming consistency
@onready var planet_spawn_3: Marker2D = $Planetspaen_3  # Fixed typo in variable name

# Default spawn probabilities (can be modified at runtime)
var spawn_ranges = [
	{"range": 30, "spawn_point": 0},  # planet_spawn_1
	{"range": 60, "spawn_point": 1},  # planet_spawn_2  
	{"range": 90, "spawn_point": 2}   # planet_spawn_3
]

# Cache spawn points for better performance
var spawn_points: Array[Marker2D] = []

func _ready() -> void:
	setup_spawn_points()
	generate_random_outcome()
	
	# Connect timer signal if it exists
	var timer = get_node_or_null("NewItemTimer")  # Assuming timer name
	if timer and timer.has_signal("timeout"):
		timer.timeout.connect(_on_new_item_timeout)

func setup_spawn_points():
	# Cache spawn points in array for easier access
	spawn_points = [planet_spawn_1, planet_spawn_2, planet_spawn_3]
	
	# Validate all spawn points exist
	for i in range(spawn_points.size()):
		if not spawn_points[i]:
			push_error("Spawn point %d is null! Check node paths." % i)

func generate_random_outcome():
	if not planets:
		push_warning("Planets scene not assigned!")
		return
	
	# Generate random number between 1 and 90
	var random_number = randi_range(1, 90)
	
	# Find which spawn point to use
	var spawn_point_index = get_spawn_point_index(random_number)
	spawn_planet_at_point(spawn_point_index)

func get_spawn_point_index(random_number: int) -> int:
	# Determine spawn point based on probability ranges
	for range_data in spawn_ranges:
		if random_number <= range_data.range:
			return range_data.spawn_point
	
	# Fallback (shouldn't happen with current ranges)
	return 0

func spawn_planet_at_point(spawn_index: int):
	if spawn_index < 0 or spawn_index >= spawn_points.size():
		push_error("Invalid spawn index: %d" % spawn_index)
		return
	
	var spawn_point = spawn_points[spawn_index]
	if not spawn_point:
		push_error("Spawn point %d is null!" % spawn_index)
		return
	
	# Create and position the planet
	var new_planet = planets.instantiate()
	add_child(new_planet)
	new_planet.global_position = spawn_point.global_position
	
	print("Planet spawned at spawn point %d" % (spawn_index + 1))

func _on_new_item_timeout() -> void:
	generate_random_outcome()

# Utility function for changing spawn probabilities
func set_spawn_probabilities(prob1: int, prob2: int, prob3: int):
	# Update spawn ranges (must add up to 90 or less)
	if prob1 + prob2 + prob3 > 90:
		push_warning("Spawn probabilities exceed 90! Clamping values.")
	
	spawn_ranges[0].range = prob1
	spawn_ranges[1].range = prob1 + prob2
	spawn_ranges[2].range = prob1 + prob2 + prob3

# Debug function to test spawn distribution
func debug_spawn_distribution(test_count: int = 1000):
	var spawn_counts = [0, 0, 0]
	
	for i in range(test_count):
		var random_number = randi_range(1, 90)
		var spawn_index = get_spawn_point_index(random_number)
		spawn_counts[spawn_index] += 1
	
	print("=== SPAWN DISTRIBUTION TEST (n=%d) ===" % test_count)
	for i in range(spawn_counts.size()):
		var percentage = (spawn_counts[i] * 100.0) / test_count
		print("Spawn Point %d: %d spawns (%.1f%%)" % [i + 1, spawn_counts[i], percentage])
