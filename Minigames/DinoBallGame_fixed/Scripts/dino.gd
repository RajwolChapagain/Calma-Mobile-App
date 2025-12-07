extends CharacterBody2D

const GRAVITY := 2000.0
const JUMP_SPEED := -900.0
const GROUND_Y := 260.0

var velocity_y := 0.0
var frozen := false
signal died

func _ready() -> void:
	visible = true
	

func _physics_process(delta: float) -> void:
	if frozen:
		return

	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if _is_on_ground():
			velocity_y = JUMP_SPEED

	velocity_y += GRAVITY * delta
	position.y += velocity_y * delta

	if position.y > GROUND_Y:
		position.y = GROUND_Y
		velocity_y = 0.0

	queue_redraw()

func _is_on_ground() -> bool:
	return abs(position.y - GROUND_Y) < 0.5



func die() -> void:
	emit_signal("died")
