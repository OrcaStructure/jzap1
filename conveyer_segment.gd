extends Area2D

var conveyer
var direction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Parcel and body.parcel_mode != "on_spinner" and body.parcel_mode != "dragging" and !body.high_up and !conveyer.endpoint.occupied and body.parcel_mode != "destination":
			body.parcel_mode = "conveyer"
			body.conveyer_velocity = 200 * direction
			
