extends Timer

@onready var spawn_1: Marker2D = $spawn_1
@onready var spawn_2: Marker2D = $spawn_2
@onready var spawn_3: Marker2D = $spawn_3
@onready var spawn_4: Marker2D = $spawn_4
@export var meat: PackedScene

var ing:int
var spaw

func _ready() -> void:
	_on_timeout()

func _on_timeout() -> void:
	#where is it spawning 
	var spawn_choice = randf()
	$"..".level_up()
	
	if spawn_choice <= 0.25:
		print("spawn point 1 chosen ,Spawn:",spaw)
		spaw = spawn_1
		spawn_ing()
	if spawn_choice <= 0.50 and spawn_choice > 0.25:
		spaw = spawn_2
		print ("spawn point 2 chosen ,Spawn:",spaw)
		spawn_ing()
	if spawn_choice > 0.50 and spawn_choice <= 0.75:
		spaw = spawn_3
		print("spawn point 3 chosen ,Spawn:",spaw)
		spawn_ing()
	if spawn_choice > 0.75:
		print ("spawn point 4 chosen ,Spawn:",spaw)
		spaw = spawn_4
		spawn_ing()
	elif spawn_choice > 1:
		print("how did you get this number, there isn't a spawn assigned here!",spaw)
		spawn_ing()
		spaw = -1

func spawn_ing():
	var ing_choice = randf()
	#what is it spawning
	if ing_choice <= 0.25:
		print("ing 1 chosen",",ing:",ing)
		ing = 1
	if ing_choice <= 0.50 and ing_choice > 0.25:
		print ("ing 2 chosen",",ing:",ing)
		ing = 2
	if ing_choice > 0.50 and ing_choice <= 0.75:
		print("ing 3 chosen",",ing:",ing)
		ing = 3
	if ing_choice > 0.75:
		print ("ing 4 chosen",",ing:",ing)
		ing = 4
	elif ing_choice > 1:
		print("how did you get this number, there isn't a ing assigned here!",ing_choice)
		ing = -1
	finish_spawn()

func finish_spawn():
	var spawn:= meat.instantiate()
	spaw.add_child(spawn)
	print("Spawned ",meat," at spawn_1")
