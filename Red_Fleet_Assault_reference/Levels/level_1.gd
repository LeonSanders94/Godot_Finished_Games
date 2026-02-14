# level_1.gd - FIXED VERSION
extends Node2D

@onready var player = %Player
@onready var camera: Camera2D = $camera

## Movement Constants ##
const PLAYER_START_POS := Vector2i(600, 485)
const CAM_START_POS := Vector2i(576, 324)
const START_SPEED: float = 10.0
const SPAWNER_START_POS := Vector2i(576, 216)

## Game State ##
var screen_size: Vector2i
var enemy_count: int
var in_zone: bool = false


## Adventure Positions ##
var adv_positions: Array[Vector2] = [
	Vector2(288, 360),
	Vector2(464, 206),
	Vector2(240, 260),
	Vector2(304, 270),
]

func _ready():
	screen_size = get_window().size
	Player.Wave = 1
	$camera/AudioStreamPlayer2D.play()
	
	# Initialize remaining adventure positions
	while adv_positions.size() < 16:
		adv_positions.append(Vector2(304, 270))
	
	new_game()

func new_game():
	# Reset position and level
	Player.Wave = 1
	player.position = PLAYER_START_POS
	player.velocity = Vector2.ZERO
	camera.position = CAM_START_POS
	RedFleet.fighter_count = 0

	get_tree().paused = true
	%Wave_status.show()
	$camera/Wave_status/Wave_number.show()
	await get_tree().create_timer(2.0).timeout
	$camera/AudioStreamPlayer2D2.play()
	$camera/AudioStreamPlayer2D.stop()
	%Wave_status.hide()
	$camera/Wave_status/Wave_number.hide()
	get_tree().paused = false
	Levels.paused = false


# Rest of your functions remain the same...
func _on_play_zone_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
		
	var flight_direction = randi() % 50
	var left_f_right_t: bool = flight_direction <= 20
	
	if RedFleet.belongs_in_RF:
		RedFleet.fighter_count += 1

func _on_play_zone_body_exited(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
		
	if RedFleet.belongs_in_RF:
		RedFleet.fighter_count -= 1

func end_of_wave():
	Player.Wave += 1

func _on_wave_timer_timeout() -> void:
	end_of_wave()

func _on_main_menu_button_up() -> void:
	cleanup_remaining_objects()
	reset_run_data()
	get_tree().paused = false
	Levels.paused = false
	Powerups.ship_choice = Powerups.weapons.basic
	
	if ResourceLoader.exists("res://UI/UI_Screens/main_menu.tscn"):
		get_tree().change_scene_to_file("res://UI/UI_Screens/main_menu.tscn")
	else:
		print("Warning: main_menu.tscn not found!")
		get_tree().change_scene_to_file("res://UI/UI_Screens/ship_select.tscn")

func _on_exit_game_button_up() -> void:
	get_tree().quit()

func _on_retry_button_up() -> void:
	cleanup_remaining_objects()
	reset_run_data()
	get_tree().paused = false
	Levels.paused = false
	get_tree().reload_current_scene()

func reset_run_data():
	cleanup_remaining_objects()
	print("Resetting run data and ship choice...")
	
	# Reset wave and money
	Player.Wave = 1
	Player.money = 0
	Player.Player_Attributes.player_score = 0
	
	# Reset player health and resources
	Player.Player_Attributes.player_current_HP = Player.Player_Attributes.player_hp_total
	Player.Player_Attributes.player_shield_current = Player.Player_Attributes.player_shield_max
	Player.Player_Stats.repair_kits = 3
	Player.Player_Attributes.weapon_cooldown = 0
	
	# Reset run statistics
	Player.report.Total_kills = 0
	Player.report.Fighter_kills = 0
	Player.report.Bomber_kills = 0
	Player.report.Carrier_kills = 0
	Player.report.Total_hits = 1
	Player.report.Total_shots = 1
	Player.report.Accuracy = 0
	Player.report.Damage_taken = 0
	Player.report.Damage_dealt = 0
	Player.report.Total_Money_Collected = 0
	
	# Reset enemy/fleet state
	RedFleet.fighter_count = 0
	RedFleet.bomber_count = 0
	RedFleet.EOW = false
	Player.Carrier_count = 2
	
	# Reset all player stats to default
	Player.Player_Stats.health = 0
	Player.Player_Stats.armor = 0
	Player.Player_Stats.shield = 0
	Player.Player_Stats.speed = 0
	Player.Player_Stats.damage = 0
	Player.Player_Stats.fire_rate = 0.0
	Player.Player_Stats.robomechanic = 0
	Player.Player_Stats.maneuvering = 0
	Player.Player_Stats.robo_ai_integrations = 0
	Player.Player_Stats.life_steal = 0
	Player.Player_Stats.mag_size = 0
	
	# Reset player attributes that depend on stats
	Player.Player_Attributes.player_hp_total = 100
	Player.Player_Attributes.player_current_HP = 100
	Player.Player_Attributes.player_shield_max = 0
	Player.Player_Attributes.player_shield_current = 0
	Player.Player_Attributes.player_alive = true
	Player.Player_Attributes.player_attk_dmg = 1
	Player.Player_Attributes.magnet = false
	Player.Player_Attributes.robos = 0
	Player.Player_Attributes.regen = 0
	Player.Player_Attributes.robos = 0
	Player.Player_Attributes.robo_dmg = 0.5
	Player.Player_Attributes.leech = 0
	Player.chaos = 0
	Player.Player_Attributes.player_weapon_main = Powerups.weapons.basic
	Player.Player_Attributes.player_weapon_dmg = Powerups.weapons.basic.dmg
	Player.Player_Attributes.player_weapon_color = Powerups.weapons.basic.color_p

	# Reset speed modifier
	Player.speed_mod = 0
func cleanup_remaining_objects():
	print("Cleaning up bullets, enemies, and debris...")
	
	# Set EOW to trigger bullet cleanup
	RedFleet.EOW = true
	
	# Wait a frame for bullets to process the EOW flag
	await get_tree().process_frame
	
