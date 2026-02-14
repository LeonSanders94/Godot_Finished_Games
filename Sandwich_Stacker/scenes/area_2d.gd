extends Area2D

var caught_stack: Array[Node2D] = []
var stack_spaces: float = 10

func catch_ingredient(object):
	caught_stack.append(object)
	object.is_caught = true

func update_stack_positions():
	for i in caught_stack.size():
		var target_pos = Vector2(0, -i * stack_spaces)
		caught_stack[i].position = target_pos


func _on_body_entered(body: CharacterBody2D) -> void:
	catch_ingredient()
