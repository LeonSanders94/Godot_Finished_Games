extends Node
@onready var sqwelch: AudioStreamPlayer2D = $Area2D/sqwelch

var meat_score = 0
var victory_score = 0
var Winner_count = 0
var winner = false
var Linus_health = 3
var game_over = false
var slimepos = Vector2()
var off = 0
var slime_damage = false
var linus_jump = false

func _process(delta):
	#print(McpGlobal.slimepos)
	if McpGlobal.meat_score >= 10 and McpGlobal.victory_score == 1:
		McpGlobal.Winner_count += 1
		print("You WIN!")
		McpGlobal.winner = true
		print(McpGlobal.winner)
	
	if Linus_health == 0:
		#print("Game Over!")
		game_over = true
