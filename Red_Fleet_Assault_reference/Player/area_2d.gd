extends Area2D
@onready var magnet: AnimatedSprite2D = $magnet2/magnet
var pull = false
var pulse_tween: Tween
var is_active = false
var current_size = 0  # Track current size to detect changes
var pulse_duration = 2.0  # How long each pulse cycle takes
var min_alpha = 0.3  # Minimum opacity (never fully transparent)
var max_alpha = 1.0  # Maximum opacity
var base_scale = 1.0  # Base scale multiplier
var size_multiplier = 0.2  # How much each mag_size level increases scale

func _ready() -> void:
	# Start completely transparent and hidden
	modulate.a = 0.0
	hide()

func _process(delta):
	var should_be_active = Player.Player_Attributes.magnet == true
	var mag_size = Player.Player_Stats.mag_size
	
	# Check if magnet ability status changes
	if should_be_active != is_active:
		is_active = should_be_active
		
		if should_be_active:
			update_size(mag_size)
			start_pulsing()
		else:
			stop_pulsing()
	
	# Check if size has changed while active
	elif should_be_active and mag_size != current_size:
		update_size(mag_size)
	
	# Set collision properties based on active state
	monitoring = should_be_active
	monitorable = should_be_active

func update_size(mag_size: int):
	current_size = mag_size
	# Calculate new scale based on mag_size
	var new_scale = base_scale + (mag_size * size_multiplier)
	scale = Vector2(new_scale, new_scale)

func start_pulsing():
	show()
	
	# Kill existing tween if running
	if pulse_tween:
		pulse_tween.kill()
	
	# Create pulsing tween that loops
	pulse_tween = create_tween()
	pulse_tween.set_loops()  # Infinite loop
	pulse_tween.set_ease(Tween.EASE_IN_OUT)
	pulse_tween.set_trans(Tween.TRANS_SINE)
	
	# Pulse from min to max and back
	pulse_tween.tween_property(self, "modulate:a", max_alpha, pulse_duration / 2)
	pulse_tween.tween_property(self, "modulate:a", min_alpha, pulse_duration / 2)

func stop_pulsing():
	# Kill existing tween if running
	if pulse_tween:
		pulse_tween.kill()
	
	# Fade out completely
	var fade_tween = create_tween()
	fade_tween.set_ease(Tween.EASE_OUT)
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(hide)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method('pullable'):
		area.pullable()

func _on_area_exited(area: Area2D) -> void:
	pull = false
