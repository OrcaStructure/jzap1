class_name Parcel
extends CharacterBody2D
var drag_rotation_velocity = 0
var conveyer_velocity
var parcel_mode = "static"
var bird
var fuse_id
var first_conveyer = true
var number
var debug = false
var bounce_time = 0
var fuse = false
var day
var game_loop
var dragging
var crouch_time
var start_pos
var predestined = true
var flung_direction
var flung_destination
var high_up = false
var destination_node
var flung_air_time = -1
var mouse_click_position
var destination_target
var validation_timer = 0
var collision_shape
var bounced = false
var timer = 0
var rejected = false
var last_rejected = false
var sorters = []
var animater
var parcel_kind
func _ready() -> void:
	input_pickable = true
	collision_shape = get_node("CollisionShape2D")
	animater = get_node('Sprite2D')
	parcel_kind = number[0]
	if parcel_kind == "default":
		animater.play("default")
		animater.set_frame_and_progress(number[1]-1,0)
	elif parcel_kind == "blue":
		animater.play("blue")
		animater.set_frame_and_progress(number[1],0)
	elif parcel_kind == "red":
		animater.play("red")
		animater.set_frame_and_progress(number[1],0)
	elif parcel_kind == "black":
		if number[1] == 0:
			animater.play("black1")
		elif number[1]==2:
			animater.play('black3')
		else:
			animater.play("black2")
	animater.pause()
	
func is_off_screen():
	var collider_shape = collision_shape.shape as RectangleShape2D
	var rect = Rect2(-collider_shape.size / 2, collider_shape.size / 2)
	var final_rect = collision_shape.get_global_transform_with_canvas() * rect
	var viewport = get_viewport().get_visible_rect()	

	return !viewport.encloses(final_rect)
	
func _input_event(viewport,event, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and !game_loop.parcel_dragging:
			parcel_mode = "dragging"
			game_loop.parcel_dragging = true
			mouse_click_position = get_global_mouse_position()
		else:
			game_loop.parcel_dragging = false
			if not mouse_click_position:	
				mouse_click_position = get_global_mouse_position()

			if (mouse_click_position - get_global_mouse_position()).length() < 10:
				click_parcel()
			parcel_mode = "static"
			rotation = 0

func click_parcel():
	if fuse:
		defuse()

func defuse():
	fuse = false
	if fuse_id != AudioStreamPlaybackPolyphonic.INVALID_ID:
		Sfx.playback.stop_stream(fuse_id)

	if number[1] == 0:
		animater.play("black1")
	elif number[1] == 2:
		animater.play("black3")
	else:	
		animater.play("black2")
	animater.pause()

func _physics_process(delta: float) -> void:
	predestined = true
	timer += delta
	
	if parcel_mode == "done":
		if fuse:
			defuse()
		collision_shape.disabled = true 
	if is_off_screen() and bounced == false and parcel_mode != "bird" and parcel_mode != "dragging":
			print('off screen')
			parcel_mode = "static"
			collision_shape.disabled = false

			var direction = Vector2(650,350)-position
			position += delta * direction
			#fling_self()
			#flung_destination = (2* position - Vector2(750,350))/3
			#bounced = true
			#bounce_time = timer
	
	if parcel_mode != "bird" and parcel_mode != "validating" and parcel_mode != "done" and parcel_kind == "black" and randf() < 0.001 and parcel_mode != "flung" and parcel_mode != "on_spinner":
		print("lit")
		fuse_id = Sfx.play(preload("res://sfx/fuse.wav"))
	
		if number[1] == 0:
			animater.play("fuse1")
		elif number[1] == 2:
			animater.play("fuse3")
		else:	
			animater.play("fuse2")
		fuse = true
	
	if fuse:
		if ((number[1] == 0 and animater.frame == 7) or (number[1] == 1 and animater.frame == 9) or (number[1] == 2 and animater.frame == 8)):
			defuse()
			game_loop.explode()
			
			
	if parcel_mode == "conveyer":
		if first_conveyer:
			first_conveyer = false
		var random_threshold = 0.01
		if parcel_kind == "blue" and ((randf() < random_threshold and day > 1) or (day ==1 and position.x > 150 and position.x < 180)):
			parcel_mode = "crouch"
			crouch_time = timer
			return
		bounced= false
		var collision_info = move_and_collide(conveyer_velocity*delta)
		parcel_mode = "unconveyer"
		if collision_info:
			
			var collider = collision_info.get_collider()
			if collider is Spinner:
				parcel_mode = "on_spinner"
				collision_shape.disabled = true
				if fuse:
					defuse()
				collider.spin_parcel(self)
			elif collider is Destination:
				if fuse:
					defuse()
				collider.consume_parcel(self)
			
	elif parcel_mode == "flung":
		predestined = false
		collision_shape.disabled = true
		
			
		
		if (position - flung_destination).length() < 10:
			parcel_mode = "static"
			Sfx.play(preload("res://sfx/thud.wav"),0.2)
			collision_shape.disabled = false
			bounced = false
		flung_direction = 750 * (flung_destination - position).normalized()
		var colllision_info = move_and_collide(flung_direction*delta)  
	elif parcel_mode == "dragging":
		position = get_global_mouse_position()
		if rotation > 0:
			drag_rotation_velocity -= 90 * delta
		else:
			drag_rotation_velocity += 90 * delta
		rotation += drag_rotation_velocity * delta
		#var mouse_direction = (get_global_mouse_position()-position).normalized()
		#position += 3000 * mouse_direction * delta
	elif parcel_mode == "destination":
		debug = true
		if scale.length() > 0.05:
			destination_node.occupied = true
			var direction = (destination_target + Vector2(0,-30)-position).normalized()
			position += direction * 100 * delta
			scale *= 0.95
		else:
			destination_node.occupied = false
			parcel_mode = "validating"
			if rejected:
				destination_node.game_loop.get_node("invalid").show_text()
			
	elif parcel_mode == "validating":
		if fuse:
			defuse()
		validation_timer += delta
		if validation_timer > 1:
			if rejected == true:
				game_loop.invalid_count += 1
				rejected = false
				last_rejected = true
				destination_node.eject_random_parcels(self)
			else:
				collision_shape.disabled = true
				parcel_mode = "done"
	elif parcel_mode == "bird":
		if (start_pos+Vector2(0,-20)-position).length() < 20:
			parcel_mode = "static"
			collision_shape.disabled = false
			bird.game.bird_on_the_way = false
			Sfx.play(preload("res://sfx/thud.wav"),0.05)

		else:
			position = bird.position + Vector2(0,30)
			collision_shape.disabled = true
	elif parcel_mode == "crouch":
		scale.y *= 0.99
		if timer > crouch_time + 0.5:
			scale.y =1
			Sfx.play(preload("res://sfx/bounce.wav"))

			fling_self()
func fling_self():
	if timer < bounce_time + 3:
		return
	scale = Vector2(1.0,1.0)
	parcel_mode = "flung"
	bounced = false
	var random_angle = randf_range(0,2 * PI)
	flung_destination = position + 200 * Vector2(cos(random_angle),sin(random_angle))
