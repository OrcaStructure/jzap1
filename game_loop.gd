extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spinner = load("res://spinner.tscn")
	var conveyer_scene = load("res://conveyer.tscn")
	var parcel = load("res://parcel.tscn")
	var spinner_instance = spinner.instantiate()
	var spinner_instance2 = spinner.instantiate()
	var parcel_instance = parcel.instantiate()
	var conveyer1 = conveyer_scene.instantiate()
	var conveyer2 = conveyer_scene.instantiate()
	
	conveyer1.start_pos = Vector2(0,500)
	conveyer1.end_pos = Vector2(600,500)
	conveyer2.start_pos = Vector2(600,340)
	conveyer2.end_pos = Vector2(1000,340)
	add_child(conveyer1)
	add_child(conveyer2)
	add_child(spinner_instance2)
	add_child(spinner_instance)	
	add_child(parcel_instance)	
	spinner_instance.position = Vector2(500,500)
	spinner_instance2.position = Vector2(1000,340)

	parcel_instance.position = Vector2(50,500)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
