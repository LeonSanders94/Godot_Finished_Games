extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Movement constants
const BASE_SPEED = 0
const MIN_SPEED_MOD = 100
const MAX_SPEED_MOD = 150

# Preload textures
const TEXTURES = {
	"green_planet": preload("res://Background/New_bg/grnplnt.png"),
	"blue_planet": preload("res://Background/New_bg/blue_pl.png"),
	"jupiter_planet": preload("res://Background/New_bg/juip.png"),
	"saturn_planet": preload("res://Background/New_bg/sat.png"),
	"grey_planet": preload("res://Background/New_bg/grey_pl.png"),
	"asteroid_1": preload("res://Background/New_bg/ast_1_md.png"),
	"asteroid_2": preload("res://Background/New_bg/ast_2_md.png"),
	"asteroid_large": preload("res://Background/New_bg/ast_lg.png")
}

# Spawn probability ranges (cumulative percentages)
const SPAWN_CHANCES = [
	{"range": 15, "type": "green_planet", "name": "Green Planet"},
	{"range": 30, "type": "blue_planet", "name": "Blue Planet"},
	{"range": 45, "type": "jupiter_planet", "name": "Jupiter-like Planet"},
	{"range": 60, "type": "saturn_planet", "name": "Saturn-like Planet"},
	{"range": 70, "type": "grey_planet", "name": "Grey Planet"},
	{"range": 80, "type": "asteroid_1", "name": "Medium Asteroid 1"},
	{"range": 90, "type": "asteroid_2", "name": "Medium Asteroid 2"},
	{"range": 100, "type": "asteroid_large", "name": "Large Asteroid"}
]

var speed_modifier: int

func _ready() -> void:
	generate_random_background_object()
	
	# Connect timer signal if it exists
	var timer = get_node_or_null("Timer")
	if timer and timer.has_signal("timeout"):
		timer.timeout.connect(_on_timer_timeout)

func generate_random_background_object():
	# Generate random number between 1 and 100
	var random_number = randi_range(1, 100)
	speed_modifier = randi_range(MIN_SPEED_MOD, MAX_SPEED_MOD)
	
	print("Generated number: %d, Speed modifier: %d" % [random_number, speed_modifier])
	
	# Find which object to spawn based on probability ranges
	for spawn_data in SPAWN_CHANCES:
		if random_number <= spawn_data.range:
			set_background_object(spawn_data.type, spawn_data.name)
			break

func set_background_object(texture_type: String, display_name: String):
	if texture_type in TEXTURES:
		sprite_2d.texture = TEXTURES[texture_type]
		print("Spawned: %s" % display_name)
	else:
		push_error("Unknown texture type: %s" % texture_type)

func _physics_process(delta: float) -> void:
	# Move background object downward
	velocity.y = BASE_SPEED + speed_modifier
	move_and_slide()
	
	# Optional: Clean up if too far off screen
	if position.y > get_viewport().size.y + 200:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

# Debug function to test spawn rates
func debug_spawn_rates(test_count: int = 1000):
	var spawn_counts = {}
	
	# Initialize counters
	for spawn_data in SPAWN_CHANCES:
		spawn_counts[spawn_data.name] = 0
	
	# Run simulation
	for i in range(test_count):
		var random_number = randi_range(1, 100)
		for spawn_data in SPAWN_CHANCES:
			if random_number <= spawn_data.range:
				spawn_counts[spawn_data.name] += 1
				break
	
	# Print results
	print("=== SPAWN RATE TEST (n=%d) ===" % test_count)
	for spawn_name in spawn_counts:
		var percentage = (spawn_counts[spawn_name] * 100.0) / test_count
		print("%s: %d spawns (%.1f%%)" % [spawn_name, spawn_counts[spawn_name], percentage])
