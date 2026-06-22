extends CharacterBody2D

var game
func _ready() -> void:
	var collider = get_node("CollisionShape2D")
	collider.disabled = true
	var animater = get_node("AnimatedSprite2D")
	animater.play('default')
func _process(delta: float) -> void:
	position.y -= delta * 300
	if position.y < -100:
		queue_free()
