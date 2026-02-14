class_name Item
extends Resource

@export var display_name: String
@export var icon: Texture2D
@export var cost: int = 12
@export var Attribute = Player.Player_Stats

func _on_use() -> bool:
	return false
