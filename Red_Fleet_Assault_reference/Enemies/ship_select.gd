extends Control

@onready var old_faithful: Button = $Panel/Old_Faithful
@onready var royal_spear: Button = $Panel/Royal_Spear
@onready var drone_bus: Button = $Panel/Drone_Bus
@onready var ship_info: Label = $Ship_info
@onready var ship: TextureRect = $Ship_info/ship
@onready var ship_stats: Label = $ship_stats
const PLAYER_SHIP_1 = preload("res://Player/Player_ship_1.png")
const ROYAL_SPEAR = preload("res://Player/Royal_Spear.png")
const DRONE_BUS = preload("res://Player/Drone_Bus.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_old_faithful_mouse_entered() -> void:
	ship.texture = PLAYER_SHIP_1
	ship_info.text = "Old Faithful"
	ship_stats.text = 'The Basic Ship, no bells or whistles here.'
	

func _on_royal_spear_mouse_entered() -> void:
	ship.texture = ROYAL_SPEAR
	ship_info.text = "Royal Spear"
	ship_stats.text = "Royal Interceptor of the King\n Speed +2 \n Shield +1\n Armor -1"

	
func _on_drone_bus_mouse_entered() -> void:
	ship.texture = DRONE_BUS
	ship_info.text = "Drone Bus"
	ship_stats.text = "Old war tech restored for use to fight the Red fleet another day\n Robo AI Integrations x2\n Speed -1\n Rate of Fire -1"

func game_on():
	get_tree().change_scene_to_file(("res://Levels/level_1.tscn"))

func _on_old_faithful_button_up() -> void:
	Powerups.ship_choice = Powerups.weapons.basic
	game_on()

func _on_royal_spear_button_up() -> void:
	Powerups.ship_choice = Powerups.weapons.royal_spear
	game_on()

func _on_drone_bus_button_up() -> void:
	Powerups.ship_choice = Powerups.weapons.drone_Bus
	game_on()
