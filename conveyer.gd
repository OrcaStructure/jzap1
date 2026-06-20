extends Node2D

var start_pos
var end_pos
var segments = []
var track_vector
var endpoint
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func on_creation():
	var segment_scene = load("res://conveyer_segment.tscn")
	var track_vector_unnormalised = end_pos - start_pos
	track_vector = track_vector_unnormalised.normalized()
	var count = roundf((track_vector_unnormalised).length() / 200)
	for i in range(count):
		var segment = segment_scene.instantiate()
		segment.position = start_pos + i * 200 * track_vector
		segment.rotation = atan2(track_vector.y,track_vector.x)
		segment.direction = track_vector
		segment.conveyer = self
		add_child(segment)
	end_pos = start_pos + (count-1) * 200 * track_vector + 120 * track_vector
	start_pos = start_pos - 100 * track_vector
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
