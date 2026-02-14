extends Marker2D

@export var carrier: PackedScene

var Carrier_count = Player.Carrier_count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_carrier_spwn_tmr_timeout() -> void:

	carrier_check()
	
func spawn_carrier():
	#print("Hello from spawn_carrier")
	if Carrier_count >= 0 and Player.Wave >= 10:
		spawner()
	

func carrier_check():
	#print('Hello from carrier_check')
	if Player.Player_Attributes.player_current_HP < Player.Player_Attributes.player_hp_total:
		Player.Player_Attributes.player_current_HP += Player.Player_Attributes.regen
	if Player.Player_Attributes.player_current_HP > Player.Player_Attributes.player_hp_total:
		Player.Player_Attributes.player_current_HP = Player.Player_Attributes.player_hp_total
	if Player.Wave >= 10:
		Carrier_count -= 2
		spawn_carrier()
		#print('spawn decision_Carrier:')
func spawner():
		var spawn_car := carrier.instantiate()
		add_child(spawn_car)
		#print('Spawn Carrier')
		spawn_car.global_position = global_position
	#if red_fleet_spawn == 0  :
