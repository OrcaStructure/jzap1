class_name Parcel
extends CharacterBody2D
var drag_rotation_velocity = 0
var conveyer_velocity
var parcel_mode = "static"
var dragging
var flung_direction
var high_up = false
var destination_node
var flung_air_time = -1
var mouse_click_position
var destination_target
var validation_timer = 0
var collision_shape
var bounced = false
var rejected
func _ready() -> void:
	input_pickable = true
	collision_shape = get_node("CollisionShape2D")
	

	
func is_off_screen():
	var collider_shape = collision_shape.shape as RectangleShape2D
	var rect = Rect2(-collider_shape.size / 2, collider_shape.size / 2)
	var final_rect = collision_shape.get_global_transform_with_canvas() * rect
	var viewport = get_viewport().get_visible_rect()	

	return !viewport.encloses(final_rect)
	
func _input_event(viewport,event, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			parcel_mode = "dragging"
			mouse_click_position = get_global_mouse_position()
		else:
			if not mouse_click_position:	
				mouse_click_position = get_global_mouse_position()

			if (mouse_click_position - get_global_mouse_position()).length() < 10:
				click_parcel()
			parcel_mode = "static"
			rotation = 0

func click_parcel():
	print("clicked!")

func _physics_process(delta: float) -> void:
	print(parcel_mode)
	if parcel_mode == "conveyer":
		bounced= false
		var collision_info = move_and_collide(conveyer_velocity*delta)
		parcel_mode = "unconveyer"
		if collision_info:
			
			var collider = collision_info.get_collider()
			
			if collider is Spinner:
				parcel_mode = "on_spinner"
				collider.spin_parcel(self)
			elif collider is Destination:
				collider.consume_parcel(self)
			
	elif parcel_mode == "flung":
		if is_off_screen() and bounced == false:
			print('off screen')
			flung_direction = - flung_direction
			bounced = true
		if flung_air_time < 0:
			high_up = true
			flung_air_time = randf_range(0.5,0.8)
			
		if flung_air_time < 0.4:
			high_up = false
			scale = Vector2(1.0,1.0)
		else:
			scale = Vector2(1.2,1.2)
		if flung_air_time > 0:
			flung_air_time -= delta
		if flung_air_time < 0:
			parcel_mode = "landed"
			bounced = false
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
		if scale.length() > 0.05:
			destination_node.occupied = true
			var direction = (destination_target-position).normalized()
			position += direction * 100 * delta
			scale *= 0.95
		else:
			destination_node.occupied = false
			parcel_mode = "validating"
			
	elif parcel_mode == "validating":
		validation_timer += delta
		if validation_timer > 1:
			if rejected == true:
				scale = Vector2(1.0,1.0)
				parcel_mode = "flung"
				var random_angle = randf_range(0,2 * PI)
				flung_direction = 50 * Vector2(cos(random_angle),sin(random_angle))
			else:
				parcel_mode = "done"
