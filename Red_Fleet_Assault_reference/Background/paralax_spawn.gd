extends Marker2D

@export var stars_sprite: PackedScene
@onready var stars_and_planets: Node2D = $"Stars and Planets"
@onready var parallax_node_3: ParallaxNode = $"Stars and Planets/background/ParallaxNode3"

func new_star():
	if stars_sprite == null:
		print("Error: stars_sprite PackedScene is not assigned!")
		return
	
	var spawn := stars_sprite.instantiate()
	
	# Add to the parallax node or stars container instead of the marker
	stars_and_planets.add_child(spawn)  # or parallax_node_3.add_child(spawn)
	
	# Use the marker's global position for spawning
	spawn.global_position = global_position
	print('spawned new star')

func _on_star_timer_timeout() -> void:  # Fixed function name
	new_star()
