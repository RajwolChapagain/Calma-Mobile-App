extends Area2D
signal scored
var triggered=false

func _ready():
    collision_layer=1
    collision_mask=1
    body_entered.connect(_hit)

func _hit(body):
    if triggered:return
    if body is CharacterBody2D:
        triggered=true
        emit_signal("scored")
        queue_free()
