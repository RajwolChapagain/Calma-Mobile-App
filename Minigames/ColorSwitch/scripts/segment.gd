extends Area2D

@export var color_index:int=0
@export var start_angle:float=0.0
@export var end_angle:float=90.0
@export var radius:float=120.0
@export var thickness:float=20.0

const COLORS=[Color(1,0.27,0.6),Color(0,0.9,1),Color(1,0.9,0),Color(0.6,0.3,1)]

func _ready():
    collision_layer=1
    collision_mask=1
    body_entered.connect(_hit)
    _generate_collision()
    queue_redraw()

func _draw():
    _draw_arc(start_angle,end_angle,radius,thickness,COLORS[color_index])

func _draw_arc(a1,a2,r,t,col):
    var pts=[]
    var inner=r-t
    var steps=40
    for i in range(steps+1):
        var tt=i/float(steps)
        var ang=deg_to_rad(lerp(a1,a2,tt))
        pts.append(Vector2(cos(ang),sin(ang))*r)
    for i in range(steps+1):
        var tt=1.0-i/float(steps)
        var ang=deg_to_rad(lerp(a1,a2,tt))
        pts.append(Vector2(cos(ang),sin(ang))* (r-t))
    draw_polygon(pts,[col])

func _generate_collision():
    var pts=[]
    var steps=40
    var inner=radius-thickness
    # clockwise outer
    for i in range(steps+1):
        var tt=1.0-i/float(steps)
        var ang=deg_to_rad(lerp(start_angle,end_angle,tt))
        pts.append(Vector2(cos(ang),sin(ang))*radius)
    # clockwise inner
    for i in range(steps+1):
        var tt=i/float(steps)
        var ang=deg_to_rad(lerp(start_angle,end_angle,tt))
        pts.append(Vector2(cos(ang),sin(ang))*inner)
    var poly=CollisionPolygon2D.new()
    poly.polygon=pts
    add_child(poly)

func _hit(body):
    if body.has_method("die"):
        if body.color_index != color_index:
            body.die()
