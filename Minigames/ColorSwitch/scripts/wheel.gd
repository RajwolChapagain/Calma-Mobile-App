extends Node2D
@export var rotation_speed:float=60.0
func _process(d): rotation_degrees += rotation_speed*d
