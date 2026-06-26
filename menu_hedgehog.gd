extends Node2D

var parcel
var mode = "default"
var animater
var drag_rotation_velocity = 0
var stuck_on
var default_time = 0
var flying_destination
var timer = 2
var frame_to_degrees = [160,135,110,70,45,10,-10,-40,-60,-75,-95,-135,-145,-180]
var radius = 120
var spin_velocity = 400
var spin_acceleration = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animater = get_node("AnimatedSprite2D")
	animater.play('default')



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	
	if mode == "dragging":
		parcel.position = get_global_mouse_position()
		if parcel.rotation > 0:
			drag_rotation_velocity -= 90 * delta
		else:
			drag_rotation_velocity += 90 * delta
		parcel.rotation += drag_rotation_velocity * delta
	if timer > default_time  + 3 and mode == "default":
		mode = "seeking"
		animater.play("walk")
		if parcel.position.x > position.x:
			scale.x = -abs(scale.x)
		else:
			scale.x = abs(scale.x)
	elif mode == "seeking":
		var destination = parcel.position
		var bearing = (destination - position).normalized()
		position += bearing * 150 * delta
		if (position-destination).length()< 70:
			mode = "getting_ready_to_spin"
			await animater.animation_looped
			animater.play("throw")
			mode = "spinning"
	elif mode == "spinning":
		var destination_vector = position
		while (destination_vector - position).length() < 70:
			destination_vector = Vector2(randf_range(100,1000),randf_range(550,600))
		var parcel_displacment = parcel.position - position
		var current_frame_angle = deg_to_rad(frame_to_degrees[animater.frame])
		var next_frame_number
		if animater.frame + 1 == len(frame_to_degrees):
			next_frame_number = 0
		else:
			next_frame_number = animater.frame + 1
		var next_frame_angle = deg_to_rad(frame_to_degrees[next_frame_number])
		var angle = sign(scale.x) + (1-animater.frame_progress) * current_frame_angle + animater.frame_progress * next_frame_angle
		var stick_position = position + Vector2(radius * scale.x * cos(angle), -radius * sin(angle))
		if (parcel.position - stick_position).length() < 10 - radius + (position-parcel.position).length() or (parcel.position - stick_position).length() < radius or stuck_on:
			parcel.position = stick_position
			stuck_on = true
		var perp_vector = Vector2(-parcel_displacment.y,parcel_displacment.x).normalized()
		if animater.speed_scale < 5:
			animater.speed_scale += spin_acceleration * delta
		else:
			var difference_vector = (destination_vector - parcel.position)
			var difference_length = difference_vector.length()
			var same_distance_perp_vector = perp_vector.normalized() * difference_vector.length()
			var same_distance_perp_destination = same_distance_perp_vector + parcel.position
			if (same_distance_perp_destination-destination_vector).length() < 100 * difference_length / 200:
				if randf_range(0,1) < 0.05:
					mode = "flying"
					flying_destination = destination_vector
					await animater.animation_looped
					animater.play('default')
					spin_velocity = 300
					Sfx.play(preload("res://sfx/throw.mp3"))
					stuck_on =false
	if mode == "flying":
		if (parcel.position - flying_destination).length() < 20: 
			mode = "default"
			Sfx.play(preload("res://sfx/thud.wav"))

		else:
			var flying_bearing = (flying_destination - parcel.position).normalized()
			parcel.position += delta * flying_bearing*900
		 
