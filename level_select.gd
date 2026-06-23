extends Node2D

var levels = 16
var level_completition = [3,2,3]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stars_scene = load("res://level_stars.tscn")

	for level_number in range(16):

		var stars_count
		if level_number <= len(level_completition)-1:
			stars_count =level_completition[level_number]
		elif level_number == len(level_completition):
			stars_count = -1
		else:
			stars_count = -2
		var stars = stars_scene.instantiate()
		stars.type = stars_count
		stars.scale =Vector2(0.3,0.3)

		stars.level_select = true
		var row = level_number / 4
		var column = level_number % 4
		stars.day = level_number
		stars.position = Vector2(150+200 * column,150 + 200 * row)
		add_child(stars)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
