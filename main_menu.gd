extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = load("res://ui_button.tscn")
	var levels = button.instantiate()
	var play = button.instantiate()
	levels.button_type = "level_select"
	play.button_type = "play"
	levels.position = Vector2(350,450)
	play.position = Vector2(750,450)
	add_child(levels)
	add_child(play)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
