extends Timer

var wave_counter = 1

func _process(delta: float) -> void:
	if Player.Wave == 1:
		wait_time = 20.0
	if Player.Wave == 2:
		wait_time = 30.0
	if Player.Wave == 3:
		wait_time = 35.0
	if Player.Wave == 4:
		wait_time = 40.0
	if Player.Wave == 5:
		wait_time = 50.0
	if Player.Wave >= 6:
		wait_time = 60.0
	if wait_time < 0:
		wait_time == 0
