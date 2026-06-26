extends Node2D

var day = 5
var metagame
var cutoffs = [
	[31,27],
	[55,47],
	[65,55],
	[80,66],
	[90,76],
	[105,90],
]
var time = 450
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = load("res://ui_button.tscn")
	var timer_scene = load("res://timer.tscn")
	var replay = button.instantiate()
	metagame = get_tree().root.get_node("meta_game")
	var level_completion = metagame.level_completion
	var pbs = metagame.pbs
	if len(pbs) >= day:
		if pbs[day-1] > time and time > 5:
			new_pb()
	else:
		metagame.pbs.append("")
		new_pb()
	var stars_earned = 1
	for cutoff in cutoffs[day-1]:
		if roundi(time) <= cutoff:
			stars_earned += 1
	if len(level_completion) >= day:
		if level_completion[day-1] < stars_earned and time > 5:
			metagame.level_completion[day-1]= stars_earned
	else:
		level_completion.append(stars_earned)
	metagame.save_game()
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
	stars.type = stars_earned
	stars.day = day
	replay.button_type = "replay"
	replay.button_destination = day
	levels.button_type = "level_select"
	timer.position = Vector2(550,350)
	stars.position = Vector2(550,250)
	levels.position = Vector2(350,450)
	replay.position = Vector2(550,450)
	add_child(stars)
	add_child(replay)
	add_child(timer)
	add_child(levels)

func new_pb():
	metagame.pbs[day-1] = time
	var new_pb_scene = load("res://newpb.tscn")
 	
	var new_pb = new_pb_scene.instantiate()
	new_pb.position = Vector2(700,300)
	add_child(new_pb)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
