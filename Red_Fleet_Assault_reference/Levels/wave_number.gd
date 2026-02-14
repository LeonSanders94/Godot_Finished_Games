extends Label

func _ready():
	UiManager.register_ui_element("wave", self, "update_wave_display")
	update_wave_display(Player.Wave)

func update_wave_display(wave_value: int):
	self.text = str('Wave: ', wave_value)
