class_name Spinner
extends StaticBody2D
var game_loop
var occupied = false
var sorter
var stuck_on
var occupied_time =0
var timer = 0
var radius = 72
var demonstrated = true
var occupying_parcel
var last_perp_vector
var parcel_attached = false
var spin_velocity = 400
var spin_acceleration = 3
var destination_vector = Vector2(500,500)
var animater
var frame_to_degrees = [160,135,110,70,45,10,-10,-40,-60,-75,-95,-135,-145,-180]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animater = get_node("AnimatedSprite2D") # Replace with function body.

func get_frame_delta():
	return 1.0 / (animater.sprite_frames.get_animation_speed("spin")*absf(animater.get_playing_speed()))
func stop_spinning():
	await animater.animation_looped
	if occupied == false:
		animater.play("default")

func spin_parcel(parcel):
	occupied = true
	occupied_time = timer
	animater.play("spin")
	occupying_parcel = parcel
	destination_vector = game_loop.get_direction(self,occupying_parcel)
	if not destination_vector is Vector2:
		var random_angle = randf_range(0,2 * PI)
		destination_vector = position + 300 * Vector2(cos(random_angle),sin(random_angle))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 20 + occupied_time and occupied:
		occupied = false
		stuck_on = false
		parcel_attached = false
		stop_spinning()
		Sfx.play(preload("res://sfx/throw.mp3"),0.2)
		occupying_parcel.parcel_mode = "flung"
		occupying_parcel.flung_destination = destination_vector
		spin_velocity = 400
	if occupied == true:
		var parcel_displacment = occupying_parcel.position - position
		var current_frame_angle = deg_to_rad(frame_to_degrees[animater.frame])
		var next_frame_number
		if animater.frame + 1 == len(frame_to_degrees):
			next_frame_number = 0
		else:
			next_frame_number = animater.frame + 1
		var next_frame_angle = deg_to_rad(frame_to_degrees[next_frame_number])
		var angle = (1-animater.frame_progress) * current_frame_angle + animater.frame_progress * next_frame_angle
		var stick_position = position + Vector2(radius * cos(angle), -radius * sin(angle))
		if (occupying_parcel.position - stick_position).length() < 10 - radius + (position-occupying_parcel.position).length() or parcel_attached or (occupying_parcel.position - stick_position).length() < radius or stuck_on:
			occupying_parcel.position = stick_position
			parcel_attached = true
			stuck_on = true
		var perp_vector = Vector2(-parcel_displacment.y,parcel_displacment.x).normalized()
		last_perp_vector = perp_vector
		if animater.speed_scale < 5:
			animater.speed_scale += spin_acceleration * delta
		else:
			var difference_vector = (destination_vector - occupying_parcel.position)
			var difference_length = difference_vector.length()
			var same_distance_perp_vector = perp_vector.normalized() * difference_vector.length()
			var same_distance_perp_destination = same_distance_perp_vector + occupying_parcel.position
			if (same_distance_perp_destination-destination_vector).length() < 100 * difference_length / 200:
				if randf_range(0,1) < 0.1:
					if randf_range(0,1) < 0.35 or occupying_parcel.parcel_kind == "red" or (game_loop.day == 2 and !demonstrated):			
						demonstrated = true
						print('MISS!')
						var random_angle = randf_range(0,2 * PI)
						destination_vector += randi_range(100,200)* Vector2(cos(random_angle),sin(random_angle))
					occupied = false
					stuck_on = false
					parcel_attached = false
					stop_spinning()
					Sfx.play(preload("res://sfx/throw.mp3"),0.2)
					occupying_parcel.parcel_mode = "flung"
					occupying_parcel.flung_destination = destination_vector
					spin_velocity = 400
