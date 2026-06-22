class_name Destination
extends StaticBody2D

var occupied = false
var game_loop
var timer = 0
var eject_parcel = []
var animater
var status = "underwater"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animater = get_node("Sprite2D")
	animater.play("empty")
func consume_parcel(parcel):
	parcel.parcel_mode = 'static'
	if parcel.destination_node == self:
		return
	await animater.animation_looped
	animater.play("eat")
	status = "eating"
	parcel.destination_target = position
	parcel.parcel_mode = "destination"
	parcel.destination_node = self
	parcel.rejected = !is_valid(parcel)
	await animater.animation_finished
	status = "ready_to_idle"
func is_valid(parcel):
	game_loop.sorted_parcels.append(parcel)
	return self == parcel.sorters[-1]["destination"]

func eject_random_parcels(caller):
	caller.fling_self()
	var ejection_number = randi_range(2,4)
	for i in range(ejection_number):
		if len(game_loop.sorted_parcels) > 0:
			var parcel = game_loop.sorted_parcels.pop_front()
			parcel.destination_node.eject_parcel.append(parcel)


	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 1 and status == "underwater":
		animater.play("enterexit")
		status = "entered"
		await animater.animation_finished
		status = "ready_to_idle"
	
	if status == "ready_to_idle":
		if randf_range(0,1) < 0.05:
			status = "idle"
			animater.play('idle')
		
	while len(eject_parcel)>0:
		var parcel = eject_parcel.pop_front()
		await animater.animation_looped
		animater.play("eat")
		parcel.fling_self()
		status = "spitting"
		await animater.animation_finished
		status = "read_to_idle"
	if occupied == true:
		pass
