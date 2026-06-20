class_name Destination
extends StaticBody2D

var occupied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func consume_parcel(parcel):
	if parcel.destination_node == self:
		parcel.parcel_mode = 'static'
		return 
	parcel.destination_target = position
	parcel.parcel_mode = "destination"
	parcel.destination_node = self
	parcel.rejected = !is_valid(parcel)
	
func is_valid(parcel):
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if occupied == true:
		pass
