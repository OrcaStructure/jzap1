extends CharacterBody2D


var parcel_mode = "conveyer"
var flung_direction
var flung_air_time = -1
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if parcel_mode == "conveyer":
		var collision_info = move_and_collide(Vector2(200,0)*delta)
		if collision_info:
			parcel_mode = "on_spinner"
			var spinner = collision_info.get_collider()
			spinner.spin_parcel(self)
	elif parcel_mode == "flung":
		if flung_air_time < 0:
			flung_air_time = randf_range(0.2,0.8)
		if flung_air_time > 0:
			flung_air_time -= delta
		if flung_air_time < 0:
			parcel_mode = "landed"
		var colllision_info = move_and_collide(flung_direction*delta)  
		
