extends Marker2D


@export var fighter: PackedScene
@export var bomber: PackedScene

var spwn_0 = 0
var spwn_1 = 1
var spwn_2 = 2
var spwn_memory:int

func spawn_0(): 
  # Creates a new instance of the _spawn_scene
	var red_fleet_spawn = randi() % 2
	#print(red_fleet_spawn)
	if red_fleet_spawn == 1:
		var spawn := fighter.instantiate()
		add_child(spawn)
		print('fighter', )
		spawn.global_position = global_position
	if red_fleet_spawn == 0:
		var spawn := bomber.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		print('bomber')
  # Move the new instance to the Spawner2D position

func spawn_1(): 
  # Creates a new instance of the _spawn_scene
	var red_fleet_spawn = randi() % 2
	#print(red_fleet_spawn)
	if red_fleet_spawn == 1:
		var spawn := fighter.instantiate()
		add_child(spawn)
		print('fighter', )
		spawn.global_position = global_position
	if red_fleet_spawn == 0:
		var spawn := bomber.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		print('bomber')

func spawn_2(): 
  # Creates a new instance of the _spawn_scene
	var red_fleet_spawn = randi() % 2
	#print(red_fleet_spawn)
	if red_fleet_spawn == 1 and $".." == $Spawners_fighters:
		var spawn := fighter.instantiate()
		add_child(spawn)
		print('fighter', )
		spawn.global_position = global_position
	if red_fleet_spawn == 0 and $".." == $"../../Spawners_Bombers":
		var spawn := bomber.instantiate()
		add_child(spawn)
		spawn.global_position = global_position
		print('bomber')


				## ### ## LEVEL CONTROL ## ### ##
#############################################################################
## each 'spawn_decision' addition adds in another spawn interval Increases ##
## the amount of spawned enemeies, you will also need to increase the -->  ##
## ################## spwn_0 variables further add more ################   ##
#############################################################################
func _on_spawn_cooldown_timeout() -> void:
	var spawn_decision = randi() % 2
	if spawn_decision == 0 and spwn_memory == 1 or 2:
		spwn_memory = 0
		spawn_0()
		print('spawn decision:',spawn_decision)
	elif spawn_decision == 1 and spwn_memory == 0 or 2:
		spwn_memory = 1
		spawn_1()
		print('spawn decision:',spawn_decision)
	elif spawn_decision == 2 and spwn_memory == 0 or 1:
		spwn_memory = 2
		pass
		print('spawn decision:',spawn_decision)
	else:
		pass
