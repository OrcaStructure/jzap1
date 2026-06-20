extends CharacterBody2D


var collided_yet = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if collided_yet == false:
		var collision_info = move_and_collide(Vector2(200,0)*delta)
		if collision_info:
			collided_yet = true
			var spinner = collision_info.get_collider()
			spinner.spin_parcel(self)
