class_name Parcel
extends CharacterBody2D
var drag_rotation_velocity = 0
var conveyer_velocity
var parcel_mode = "static"
var dragging
var flung_direction
var flung_air_time = -1
var mouse_click_position

func _ready() -> void:
	input_pickable = true

func _input_event(viewport,event, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			parcel_mode = "dragging"
			mouse_click_position = get_global_mouse_position()
		else:
			if (mouse_click_position - get_global_mouse_position()).length() < 10:
				click_parcel()
			parcel_mode = "static"
			rotation = 0

func click_parcel():
	print("clicked!")

func _physics_process(delta: float) -> void:
	if parcel_mode == "conveyer":
		var collision_info = move_and_collide(conveyer_velocity*delta)
		if collision_info:
			parcel_mode = "on_spinner"
			var spinner = collision_info.get_collider()
			spinner.spin_parcel(self)
	elif parcel_mode == "flung":
		if flung_air_time < 0:
			flung_air_time = randf_range(0.5,0.8)
		if flung_air_time > 0:
			flung_air_time -= delta
		if flung_air_time < 0:
			parcel_mode = "landed"
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
