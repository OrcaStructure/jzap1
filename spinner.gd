class_name Spinner
extends StaticBody2D
var game_loop
var occupied = false
var sorter
var occupying_parcel
var last_perp_vector
var spin_velocity = 400
var spin_acceleration = 300
var destination_vector
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spin_parcel(parcel):
	occupied = true
	occupying_parcel = parcel
	destination_vector = game_loop.get_direction(self,occupying_parcel)
	if not destination_vector is Vector2:
		var random_angle = randf_range(0,2 * PI)
		destination_vector = position + 300 * Vector2(cos(random_angle),sin(random_angle))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if occupied == true:
		var parcel_displacment = occupying_parcel.position - position
		var perp_vector = Vector2(parcel_displacment.y,-parcel_displacment.x).normalized()
		last_perp_vector = perp_vector
		occupying_parcel.position += spin_velocity * delta * perp_vector
		if spin_velocity < 800:
			spin_velocity += spin_acceleration * delta
		else:
			var difference_vector = (destination_vector - occupying_parcel.position).normalized()
			if absf(perp_vector.angle_to(difference_vector)) < 0.2:
				print(perp_vector,difference_vector,last_perp_vector)
				if randf_range(0,1) < 0.4:
					occupied = false
					occupying_parcel.parcel_mode = "flung"
					occupying_parcel.flung_direction = last_perp_vector * spin_velocity
					spin_velocity = 400
