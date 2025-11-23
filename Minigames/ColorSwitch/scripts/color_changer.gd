extends Area2D

func _ready():
    collision_layer=1
    collision_mask=1
    body_entered.connect(_hit)
    queue_redraw()

func _draw():
    draw_circle(Vector2.ZERO,12,Color(1,1,1))

func _hit(body):
    if body.has_method("set_color"):
        body.set_color()
    queue_free()
