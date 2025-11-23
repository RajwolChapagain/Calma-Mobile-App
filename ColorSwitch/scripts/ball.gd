
extends CharacterBody2D

const G=1200.0
const J=-300.0

var colors=[Color(1,0.27,0.6),Color(0,0.9,1),Color(1,0.9,0),Color(0.6,0.3,1)]
var color_index=0
var radius=16.0
signal died

func _ready():
	collision_layer=1
	collision_mask=1
	randomize()
	set_color()
	queue_redraw()

func set_color():
	color_index = randi()%colors.size()
	queue_redraw()

func _physics_process(d):
	velocity.y += G*d
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity.y = J
	move_and_slide()

func _draw():
	draw_circle(Vector2.ZERO,radius,colors[color_index])

func die():
	emit_signal("died")
