extends Area2D

@export var move_speed := 350.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position.x -= move_speed * delta
	if position.x < -600:
		queue_free()

	queue_redraw()


func _on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		body.die()
