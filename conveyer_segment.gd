extends Area2D
var timer = 0
var conveyer
var direction
var animater
var speed = 100
var length_of_animation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animater = get_node("AnimatedSprite2D") # Replace with function body.
	animater.play("default")
	length_of_animation = get_total_animation_length()

func get_total_animation_length():
	var animation_length = 0
	for i in range(animater.sprite_frames.get_frame_count("default")):
		animation_length += animater.sprite_frames.get_frame_duration("default",i)
	return animation_length / animater.sprite_frames.get_animation_speed("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer < 0.1:
		return
	if !conveyer.endpoint.occupied:
		animater.speed_scale = speed / (200/length_of_animation)
	else:	
		animater.speed_scale = 0
	for body in get_overlapping_bodies():
		if body is Parcel and body.parcel_mode != "on_spinner" and body.parcel_mode != "dragging" and !body.high_up and !conveyer.endpoint.occupied and body.parcel_mode != "destination" and body.parcel_mode != "flung":
			body.parcel_mode = "conveyer"
			body.conveyer_velocity = speed * direction.normalized()
			
