extends Node

var current_score:int = 0 
var total_score = 0
var game_active:bool = false
var highscore:int = 1000

var Global_level_tracker:int

func _ready() -> void:
	load_high_score()

func load_high_score() -> void:
	var data = Save_Manager.load_game()
	highscore = data.get("highscore", 1000)

func update_high_score(new_score: int) -> void:
	if new_score > highscore:
		highscore = new_score
		save_high_score()

func save_high_score() -> void:
	Save_Manager.save_game({"highscore": highscore})
