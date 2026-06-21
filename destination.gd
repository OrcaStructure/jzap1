class_name Destination
extends StaticBody2D

var occupied = false
var game_loop
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
	game_loop.sorted_parcels.append(parcel)
	return self == parcel.sorters[-1]["destination"]

func eject_random_parcels(caller):
	caller.fling_self()
	var ejection_number = randi_range(2,4)
	for i in range(ejection_number):
		if len(game_loop.sorted_parcels) > 0:
			game_loop.sorted_parcels.pop_front().fling_self()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if occupied == true:
		pass
