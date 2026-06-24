extends Node2D

var day = 5
var time = 450
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = load("res://ui_button.tscn")
	var timer_scene = load("res://timer.tscn")
	var replay = button.instantiate()
	if day < 6:
		var next = button.instantiate()
		next.button_destination = day + 1
		next.button_type = "next_level"
		next.position = Vector2(750,450)
		add_child(next)

	var timer = timer_scene.instantiate()
	timer.time = time
	var levels = button.instantiate()
	var stars_scene = load("res://level_stars.tscn")
	var stars = stars_scene.instantiate()
	stars.type = 3
	stars.day = day
	replay.button_type = "replay"
	
	levels.button_type = "level_select"
	timer.position = Vector2(550,350)
	stars.position = Vector2(550,250)
	levels.position = Vector2(350,450)
	replay.position = Vector2(550,450)
	add_child(stars)
	add_child(replay)
	add_child(timer)
	add_child(levels)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
