extends Area2D

@export var move_speed := 350.0
var counted := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position.x -= move_speed * delta

	# ⭐ Award score when cactus passes behind dino
	if not counted:
		var dino = get_parent().get_node("Dino")
		if position.x < dino.position.x:
			counted = true
			get_parent().score += 1
			Utils.add_coins(1)
			print("Score: ", get_parent().score)

	# Remove when off-screen
	if position.x < -600:
		queue_free()

	queue_redraw()

func _on_body_entered(body: Node) -> void:
	# If the body is the dino, kill it
	if body.has_method("die"):
		body.die()
