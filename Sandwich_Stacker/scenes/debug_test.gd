extends Node

var level:int
var goal:int
var drop_limit:String
var stack_size_getter
var endless:bool

signal player_position_updated(position: Vector2)
@onready var player_platform: Node2D = %Player_platform


func _ready() -> void:
	level = 1
	goal = 200
	drop_limit = "XXX"
	endless = false
	GameInfo.current_score = 0
	GameInfo.total_score = 0
	

func _process(_delta):
	if player_platform:
		player_position_updated.emit(player_platform.global_position)
	GameInfo.Global_level_tracker = level



func level_up():
	if GameInfo.total_score >= 200:
		level = 2
		goal = 600
	if GameInfo.total_score >= 500:
		level = 3
		goal = 1000
	if GameInfo.total_score >= GameInfo.highscore:
		#print("You win!")
		win()

func win():
	print('Endless:',endless,"Highscore:",GameInfo.highscore)
	if GameInfo.total_score > GameInfo.highscore and endless == false:
		GameInfo.highscore = GameInfo.total_score
		GameInfo.save_high_score()
		endless = true
		$UI/game_info/You_Win.show()
		get_tree().paused = true
func game_over():
	$UI/Game_Over.show()
	get_tree().paused = true
