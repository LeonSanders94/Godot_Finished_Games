extends Label

func _ready():
	UiManager.register_ui_element("score", self, "update_score_display")
	update_score_display(Player.Player_Attributes.player_score)

func update_score_display(score_value: int):
	self.text = str(score_value)
