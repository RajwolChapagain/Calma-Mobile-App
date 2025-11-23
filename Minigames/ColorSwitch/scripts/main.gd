extends Node2D

@onready var ball=$Ball
@onready var cam=$Camera2D
@onready var score_label=$CanvasLayer/ScoreLabel
@onready var game_label=$CanvasLayer/GameOverLabel

var wheel_scene=preload("res://Minigames/ColorSwitch/Scenes/Wheel.tscn")
var change_scene=preload("res://Minigames/ColorSwitch/Scenes/ColorChanger.tscn")
var zone_scene=preload("res://Minigames/ColorSwitch/Scenes/ScoreZone.tscn")

var next_y
var spacing=450
var score=0
var dead=false

func _ready():
	ball.position=Vector2(0,200)
	cam.position=ball.position
	next_y=ball.position.y-250
	for i in range(4):
		_spawn()
	ball.died.connect(_die)
	game_label.visible=false
	_update_score()

func _spawn():
	var w=wheel_scene.instantiate()
	w.position=Vector2(0,next_y)
	add_child(w)
	var c=change_scene.instantiate()
	c.position=w.position+Vector2(0,220)
	add_child(c)
	var z=zone_scene.instantiate()
	z.position=w.position+Vector2(0,260)
	z.scored.connect(_score)
	add_child(z)
	next_y-=spacing

func _process(d):
	if dead:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			get_tree().reload_current_scene()
		return
	if ball.position.y < cam.position.y:
		cam.position.y = ball.position.y
	if cam.position.y - next_y < 800:
		_spawn()
	if ball.position.y > cam.position.y + 600:
		_die()

func _score():
	if dead:return
	score+=1
	_update_score()

func _update_score():
	score_label.text=str(score)

func _die():
	if dead:return
	dead=true
	game_label.visible=true
