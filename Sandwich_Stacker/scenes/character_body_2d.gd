extends CharacterBody2D

#stack tracking
var caught_stack: Array[Node2D] = []
var stack_base_positions: Array[Vector2] = []
var current_tilt: float = 0.0
var stack_spacing:float = 5
var stack_droped:bool = false
#wobble tracking
var wobble_sway_time:float = 0.0
var start_pos
var finised_sandwich = false

const SPEED = 400.0

@onready var catch_zone: Area2D = $catch_zone

# Wobble system
var wobble: float = 0.0
var wobble_threshold: float = 100.0  # when items start falling
var wobble_decay_rate: float = 30.0  # how fast wobble decreases per second
var wobble_per_speed: float = 0.15  # base wobble gain from movement
var wobble_per_item: float = 0.03  # multiplier per item in stack
func _ready() -> void:
	catch_zone.area_entered.connect(_on_catch_zone_area_entered)
	start_pos = catch_zone.position.y
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_pressed("exit_endless") and $"../..".endless == true:
		GameInfo.highscore = GameInfo.total_score
		GameInfo.save_high_score()
		get_tree().quit()
	if Input.is_action_just_released("action"):
		finised_sandwich = true
		print('completed a sandwich')
		finish_sammy()
	
	$"../..".stack_size_getter = caught_stack.size() * .5
	move_and_slide()
	update_wobble(delta)

func update_wobble(delta:float):
	#controls wobble based on speed and stack size
	var speed_magnitude = abs(velocity.x)
	var stack_multiplier = 1.0 + (caught_stack.size() * wobble_per_item)
	wobble = max(0,wobble - wobble_decay_rate * delta)
	wobble += speed_magnitude * wobble_per_speed * stack_multiplier * delta
	#print(wobble) #Check if wobble is increasing
	
	if wobble > wobble_threshold * 0.5:
		wobble_sway_time += delta * 5.0 #increases the rate in which the stack wobbles
	else:
		wobble_sway_time = 0.0  # ← Reset when stable
	
	update_stack_positions()
	
	if wobble >= wobble_threshold and caught_stack.size() > 0:
		$SlimeSquish4218568.play()
		drop_it_like_its_hot()
		drop_stack()

func drop_stack()-> void:
	print("Stack Dropped! Wobble:",wobble)
	for item in caught_stack:
		item.is_caught = false
		item.reparent(get_parent())
		item.position = global_position + item.position
	caught_stack.clear()
	stack_base_positions.clear()
	wobble = 0.0
	wobble_sway_time = 0.0
	stack_droped = true

	drop_reset()

func catch_object(object):
	caught_stack.append(object)
	object.is_caught = true
	object.reparent(self)  #child of player
	
	if object.has_method("catch_block"):
		object.catch_block()
	else: #in case the item script fails
		object.set_collision_layer_value(1, false)
		
	var base_index = caught_stack.size() - 1
	var true_pos = Vector2(0,-base_index * stack_spacing)
	stack_base_positions.append(true_pos)
	update_stack_positions()
	score_update()
	raise_the_roof()
	
func update_stack_positions():
	var tilt_angle = (wobble/ wobble_threshold) * 7.5
	var sway = sin(wobble_sway_time) * (wobble / wobble_threshold) * 15.0
	
	var target_tilt = 0.0
	
	if velocity.x > 0:
		target_tilt = -tilt_angle + sway
	elif velocity.x < 0:
		target_tilt = tilt_angle + sway
	else:
		# Slowly return to center when not moving
		target_tilt  = sway * 0.5
	
	current_tilt = lerp(current_tilt,target_tilt,0.3)
	
	rotation_degrees = current_tilt
	catch_zone.rotation_degrees = current_tilt
	
	# Safety check: don't update if arrays are out of sync or empty
	if caught_stack.size() == 0 or caught_stack.size() != stack_base_positions.size():
		return
	for i in caught_stack.size():
		var item_rotation = current_tilt * (0.4 + i * 0.1)
		var rotation_rad = deg_to_rad(item_rotation)
		
		var base_pos = stack_base_positions[i]
		
		var horizontal_offset = sin(rotation_rad) * (i * stack_spacing * 0.5)
		var vertical_offset = (1 - cos(rotation_rad)) * (i * stack_spacing * 0.15)
		
		caught_stack[i].position = base_pos + Vector2(horizontal_offset, vertical_offset)
		caught_stack[i].rotation_degrees = item_rotation

func _on_catch_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group('ingredients'):
		print("Attached!")
		catch_object(area)
	if area.is_in_group("rotten"):
		drop_stack()
		area.queue_free()
		drop_it_like_its_hot()
		$AnimatedSprite2D/CPUParticles2D.show()
		$SlimeSquish4218568.play()

func raise_the_roof():
	catch_zone.position.y -= 5
	

func drop_reset():
	if stack_droped == true:
		GameInfo.current_score -= GameInfo.current_score
		stack_droped = false
		catch_zone.position.y = start_pos

func score_update():
	GameInfo.current_score += 10 + (caught_stack.size() * 0.5)
	
func finish_sammy():
	GameInfo.total_score += GameInfo.current_score
	stack_droped = true
	$HotelBellDing1174457.play()
	drop_stack()
func drop_it_like_its_hot():
	
	
	if $"../..".drop_limit == "X":
		$"../..".drop_limit = "RIP"
		$"../..".game_over()
	if $"../..".drop_limit == "XX":
		$"../..".drop_limit = "X"
	if $"../..".drop_limit == "XXX":
		$"../..".drop_limit = "XX"
