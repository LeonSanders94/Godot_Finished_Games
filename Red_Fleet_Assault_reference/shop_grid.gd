extends GridContainer

@onready var margin_container: MarginContainer = $MarginContainer
@onready var margin_container_2: MarginContainer = $MarginContainer2
@onready var margin_container_3: MarginContainer = $MarginContainer3
@onready var margin_container_4: MarginContainer = $MarginContainer4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	margin_container.margin_top = 128


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
