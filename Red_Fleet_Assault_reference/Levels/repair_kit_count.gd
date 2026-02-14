extends Label

func _ready():
	UiManager.register_ui_element("repair_kits", self, "update_repair_kits_display")
	update_repair_kits_display(Player.Player_Stats.repair_kits)

func update_repair_kits_display(kit_count: int):
	self.text = str(kit_count)
