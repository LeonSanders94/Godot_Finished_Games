extends TextureRect

# Floating properties - using longer distances for smoother interpolation
@export var drift_speed: float = 2.0  # Pixels per second (visual reference)
@export var min_alpha: float = 0.6  # Subtle glow minimum
@export var max_alpha: float = 0.9  # Subtle glow maximum
@export var glow_duration: float = 3.0  # Glow cycle duration

# Internal variables
var start_position: Vector2
var glow_tween: Tween
var movement_tween: Tween
var total_drift_distance: float = 1000.0  # Large distance for smooth interpolation

func _ready():
	start_position = position
	start_glow()
	start_smooth_drift()

func _process(_delta: float):
	# Handle pause state
	if Levels.paused:
		reset_to_start()

func start_smooth_drift():
	if movement_tween:
		movement_tween.kill()
	
	# Calculate duration for the large distance at desired speed
	var total_time = total_drift_distance / drift_speed
	
	# Create one long, smooth tween
	movement_tween = create_tween()
	movement_tween.set_ease(Tween.EASE_IN_OUT)  # Smooth easing
	movement_tween.set_trans(Tween.TRANS_SINE)  # Sine transition for smoothness
	movement_tween.tween_property(self, "position:y", start_position.y + total_drift_distance, total_time)
	movement_tween.tween_callback(seamless_reset)

func seamless_reset():
	# Instantly move back to start
	position.y = start_position.y
	# Continue the cycle
	start_smooth_drift()

func reset_to_start():
	if movement_tween:
		movement_tween.kill()
	position = start_position
	# Don't restart movement while paused

func start_glow():
	glow_tween = create_tween()
	glow_tween.set_loops()
	glow_tween.tween_property(self, "modulate:a", min_alpha, glow_duration)
	glow_tween.tween_property(self, "modulate:a", max_alpha, glow_duration)

# Alternative: Ultra-smooth using sin wave (uncomment to try this instead)
# var time_passed: float = 0.0
# var wave_amplitude: float = 100.0  # How far it drifts
# var wave_frequency: float = 0.1    # How slow the cycle is

# func _process(delta: float):
# 	if not Levels.paused:
# 		time_passed += delta
# 		# Use sine wave for perfectly smooth movement
# 		position.y = start_position.y + sin(time_passed * wave_frequency) * wave_amplitude
# 	else:
# 		position = start_position
# 		time_passed = 0.0

func _exit_tree():
	if glow_tween:
		glow_tween.kill()
	if movement_tween:
		movement_tween.kill()
