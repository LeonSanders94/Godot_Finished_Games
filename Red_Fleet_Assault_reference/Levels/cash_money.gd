extends Label

# In BOTH cash_money.gd AND current_cash.gd
func _ready():
	UiManager.register_ui_element("money", self, "update_money_display")
	update_money_display(Player.money)

func update_money_display(money_value: int):
	self.text = str('Cash: ', money_value)

func _process(delta: float) -> void:
	update_money_display(Player.money)
