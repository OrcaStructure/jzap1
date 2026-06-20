extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spinner = load("res://spinner.tscn")
	var parcel = load("res://parcel.tscn")
	var spinner_instance = spinner.instantiate()
	var parcel_instance = parcel.instantiate()
	add_child(spinner_instance)	
	add_child(parcel_instance)	
	spinner_instance.position = Vector2(500,500)
	parcel_instance.position = Vector2(50,500)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
