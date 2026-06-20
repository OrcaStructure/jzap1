extends StaticBody2D

var occupied = false

var occupying_parcel
var last_perp_vector
var spin_velocity = 400
var spin_acceleration = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spin_parcel(parcel):
	occupied = true
	occupying_parcel = parcel
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if occupied == true:
		if spin_velocity < 800:
			spin_velocity += spin_acceleration * delta
			var parcel_displacment = occupying_parcel.position - position
			var perp_vector = Vector2(parcel_displacment.y,-parcel_displacment.x).normalized()
			last_perp_vector = perp_vector
			occupying_parcel.position += spin_velocity * delta * perp_vector
		else:
			occupying_parcel.position += last_perp_vector * spin_velocity * delta
