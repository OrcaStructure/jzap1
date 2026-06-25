extends Node2D

var levels = 6
var level_completion
var metagame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var stars_scene = load("res://level_stars.tscn")
	metagame = get_tree().root.get_node("meta_game")
	var timer_scene = load("res://timer.tscn")
	for level_number_offset in range(levels):

		var level_number = level_number_offset +1
		
		var stars_count
		if level_number <= len(level_completion):
			stars_count =level_completion[level_number_offset]
		elif level_number == len(level_completion)+1:
			stars_count = -1
		else:
			stars_count = -2
		var stars = stars_scene.instantiate()
		stars.type = stars_count
		stars.scale =Vector2(0.3,0.3)

		stars.level_select = true
		var row = level_number_offset / 3
		var column = level_number_offset % 3
		print(level_number,row,column)
		stars.day = level_number
		stars.position = Vector2(350+200 * column,250 + 200 * row)
		add_child(stars)
		if len(metagame.pbs) >= level_number:
			var timer = timer_scene.instantiate()
			timer.position = Vector2(350+200 * column,200 + 200 * row)
			timer.time = metagame.pbs[level_number -1]
			add_child(timer)
			timer.scale *= 0.25
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(metagame.pbs)
