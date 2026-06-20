extends Node2D

var start_pos
var end_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var segment_scene = load("res://conveyer_segment.tscn")
	var count = roundf((end_pos.x - start_pos.x) / 200)
	for i in range(count):
		var segment = segment_scene.instantiate()
		segment.position.x = start_pos.x + i * 200
		segment.position.y = start_pos.y
		add_child(segment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
