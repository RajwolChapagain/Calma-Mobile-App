extends Node2D

@onready var dino = $Dino
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var game_over_label = $CanvasLayer/GameOverLabel

var cactus_scene := preload("res://Minigames/DinoBallGame_fixed/Scenes/Cactus.tscn")

var spawn_timer := 0.0
var spawn_interval := 1.5
var min_spawn_interval := 0.7
var scroll_speed := 350.0
var score := 0.0
var is_game_over := false

func _ready() -> void:
	randomize()
	dino.died.connect(_on_dino_died)
	game_over_label.visible = false

func _physics_process(delta: float) -> void:
	if is_game_over:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_restart()
		return

	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn_cactus()
		spawn_interval = max(min_spawn_interval, spawn_interval - 0.03)
		spawn_timer = spawn_interval

	score += delta * 10
	score_label.text = str(int(score))

func _spawn_cactus() -> void:
	print("SPAWNING CACTUS")
	var cactus = cactus_scene.instantiate()
	var ground_y := 240.0
	cactus.position = Vector2(600.0, ground_y)
	cactus.move_speed = scroll_speed
	add_child(cactus)

func _on_dino_died() -> void:
	is_game_over = true
	dino.frozen = true
	game_over_label.visible = true

func _restart() -> void:
	get_tree().reload_current_scene()
