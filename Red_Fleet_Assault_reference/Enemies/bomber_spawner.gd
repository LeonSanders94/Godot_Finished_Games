extends Marker2D


@export var bomber: PackedScene


var spwn_0 = 0
var spwn_1 = 1
var spwn_2 = 2

var spawn_decision:int

func _process(delta):
	spawn_decision = randi() % 2000
	#print('wave:',Player.Wave)
func spawn_0(): 
	#print("Hello from spawn_0")
  # Creates a new instance of the _spawn_scene
	var red_fleet_spawn = 0
	#print(red_fleet_spawn)

	if red_fleet_spawn == 0 :
		var spawn := bomber.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		#print('bomberspawn_0')
 #  Move the new instance to the Spawner2D position

func spawn_1(): 
	#print("Hello from spawn_1")
  # Creates a new instance of the _spawn_scene
	var red_fleet_spawn = 0
	#print(red_fleet_spawn)
	if red_fleet_spawn :
		var spawn := bomber.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		#print('bomber spawn_1')

func spawn_2(): 
	#print("Hello from spawn_2")
  # Creates a new instance of the _spawn_scene
	var red_fleet_spawn = 0
	#print(red_fleet_spawn)
	if red_fleet_spawn == 0  :
		var spawn := bomber.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		#print('bomber spawn_2')

#Spawn points:


				## ### ## LEVEL CONTROL ## ### ##
#############################################################################
## each 'spawn_decision' addition adds in another spawn interval Increases ##
## the amount of spawned enemeies, you will also need to increase the -->  ##
## ###### spwn_0 variables further add more to the spawn range ##########  ##
#############################################################################

func _on_spawner_cooldown_timeout() -> void:
	#print("Hello from _on_spawn_cooldown_timeout ")
	if Player.Wave >= 2 and spawn_decision >= 0 and spawn_decision <= 200:
		spawn_0()
		#print('spawn decision_1:',spawn_decision)
	if Player.Wave >= 5 and spawn_decision >= 401 and spawn_decision <= 500:
		spawn_1()
		#print('spawn decision_2:',spawn_decision)
	if Player.Wave >= 7 and spawn_decision >= 500 and spawn_decision <= 700:
		spawn_2()
		#print('spawn decision_3:',spawn_decision)
