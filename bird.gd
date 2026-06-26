extends CharacterBody2D

var game
var noised = false
var timer = 0
func _ready() -> void:
	var collider = get_node("CollisionShape2D")
	collider.disabled = true
	var animater = get_node("AnimatedSprite2D")
	animater.play('default')
func _process(delta: float) -> void:
	timer += delta
	if timer > 2 and !noised:
		noised = true
		Sfx.play(preload("res://sfx/bird.ogg"),0.2)
	position.y -= delta * 300
	if position.y < -100:
		queue_free()
