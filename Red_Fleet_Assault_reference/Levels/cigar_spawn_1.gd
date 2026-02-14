extends Marker2D

@export var cigar_bot: PackedScene

# Cigar bot management
var cigar_bots_spawned = 0
var max_cigar_bots = 1  # Maximum cigar bots at once


func cigar_bot_check():
	# Spawn cigar bots starting from wave 4
	if Player.Wave >= 4 and cigar_bots_spawned < max_cigar_bots:
		# Random spawn decision (like your other spawners)
		var spawn_decision = randi() % 9
		if spawn_decision <= 2:  # ~33% chance to spawn
			spawn_cigar_bot()

func spawn_cigar_bot():
	if not cigar_bot:
		print("Warning: Cigar bot scene not assigned!")
		return
	
	var spawn := cigar_bot.instantiate()
	add_child(spawn)  # Spawn at this marker's position
	spawn.global_position = global_position
	
	# Track spawned count
	cigar_bots_spawned += 1
	
	# Connect to death signal to update count (if needed)
	if spawn.has_signal("enemy_died"):
		spawn.enemy_died.connect(_on_cigar_bot_died)
	
	print("Cigar bot spawned at: ", spawn.global_position)

func _on_cigar_bot_died():
	# Decrease count when cigar bot dies
	cigar_bots_spawned -= 1
	if cigar_bots_spawned < 0:
		cigar_bots_spawned = 0


func _on_cigar_time_timeout() -> void:
	cigar_bot_check()
