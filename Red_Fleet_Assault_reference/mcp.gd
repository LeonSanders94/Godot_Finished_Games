extends Node

#Calls any global with one Variable, use MCP.[variable name] to access

var map_speed:Vector2
var hp:int



func death(body):
	if hp == 0:
		body.queue_free()
