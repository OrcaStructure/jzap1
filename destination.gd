class_name Destination
extends StaticBody2D

var occupied = false
var game_loop
var most_recent_parcel
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
	most_recent_parcel = parcel

	if parcel.destination_node == self and !parcel.predestined:
		#print(parcel.last_rejected, "   ", occupied)
		return

	await animater.animation_looped
	animater.play("eat")
	Sfx.play(preload("res://sfx/chomp.wav"),0.01)
	parcel.rejected = !is_valid(parcel)

	status = "eating"
	parcel.destination_target = position
	parcel.parcel_mode = "destination"
	parcel.destination_node = self
	parcel.last_rejected = false
	print("rejected",parcel.rejected)
	await animater.animation_finished
	status = "ready_to_idle"
func is_valid(parcel):
	game_loop.sorted_parcels.append(parcel)
	return self == parcel.sorters[-1]["destination"]

func eject_random_parcels(caller):
	eject_parcel.append(caller)
	Sfx.play(preload("res://sfx/invalid.wav"))

	var ejection_number 
	if game_loop.invalid_count % 4 == 0:
		ejection_number = 6
	else:
		ejection_number = randi_range(2,4)
	for i in range(ejection_number):
		if len(game_loop.sorted_parcels) > 0:
			var parcel = game_loop.sorted_parcels.pop_front()
			parcel.destination_node.eject_parcel.append(parcel)


	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	
	if most_recent_parcel and most_recent_parcel.parcel_mode == "dragging":
		occupied = false
	
	if timer > 1 and status == "underwater":
		animater.play("enterexit")
		Sfx.play(preload("res://sfx/splash.wav"))
		status = "entered"
		await animater.animation_finished
		status = "ready_to_idle"
	
	if status == "ready_to_idle":
		if randf_range(0,1) < 0.05:
			status = "idle"
			animater.play('idle')
	
	if len(eject_parcel) >0:
		await animater.animation_looped
		animater.play("eat")
		status = "spitting"
		
		while len(eject_parcel)>0:
			var parcel = eject_parcel.pop_front()
			
			parcel.fling_self()

		await animater.animation_finished
		status = "ready_to_idle"
	if occupied == true:
		pass
