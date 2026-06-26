extends Node2D
var spinner_scene
var conveyer_scene
var parcel_scene
var metagame
var any_rejected
var sort_text
var invalid_count = 0
var parcel_dragging
var sort_count
var game_over =false
var destination_scene
var day = 3
var bird_on_the_way = false
var bird_scene
var sorted_parcels = []
var parcel_numbers_to_make = []
var sorters = []
var total_parcels
var initial_parcel_counts = {
	"default" : 42,
	"blue" : 3,
	"red" : 3,
	"black" : 3
} 
var global_start_pos
var spawned_parcels = 0
var random_generator2
var day_timer = 0 
var parcels = []
var random_generator
var level_parcels = {
	"default" : [4,9,8,7,8,6],
	"blue" : [1,0,0,1,0,1],
	"red" : [0,0,1,1,0,1],
	"black" : [0,0,0,0,1,2]
} 
func parcel_key(number):
	return (number * 7) % 23
func sorter_sort(a,b):
	return a["day"] < b["day"]
	
func add_sorter(start_pos,end_pos,terminal,sorter_day):
	sorters.append({})
	var conveyer = conveyer_scene.instantiate()
	conveyer.start_pos = start_pos
	conveyer.end_pos = end_pos
	conveyer.on_creation()
	end_pos = conveyer.end_pos
	add_child(conveyer)
	sorters[-1]["conveyer"] = conveyer
	sorters[-1]["day"] = day
	

	if terminal:
		sorters[-1]["terminal"] = true
		var destination = destination_scene.instantiate()
		destination.position = end_pos
		destination.game_loop = self
		conveyer.endpoint = destination
		add_child(destination)
		sorters[-1]["destination"] = destination
		
	else:
		sorters[-1]["terminal"] = false
		var spinner = spinner_scene.instantiate()
		spinner.game_loop = self
		spinner.position = end_pos
		conveyer.endpoint = spinner
		add_child(spinner)
		sorters[-1]["spinner"] = spinner
		spinner.sorter = sorters[-1]
	sorters[-1]["start_pos"] = conveyer.start_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_controls_scene = load("res://game_controls.tscn")
	var game_controls = game_controls_scene.instantiate()
	add_child(game_controls)
	random_generator = RandomNumberGenerator.new()
	random_generator2 = RandomNumberGenerator.new()
	random_generator.seed = day
	random_generator2.seed = day
	metagame = get_tree().root.get_node("meta_game")
	spinner_scene = load("res://spinner.tscn")
	conveyer_scene = load("res://conveyer.tscn")
	destination_scene = load("res://destination.tscn")
	var sort_text_scene = load("res://parcels_remaining.tscn")
	var sort_count_scene = load("res://to_sort_count.tscn")
	var timer_scene = load("res://timer.tscn")
	var timer =timer_scene.instantiate()
	sort_text = sort_text_scene.instantiate()
	sort_count =  sort_count_scene.instantiate()
	sort_text.position = Vector2(250,75)
	sort_count.position = Vector2(50,75)
	
	timer.position = Vector2(1000,75)
	timer.count_up = true
	add_child(timer)
	add_child(sort_count)
	add_child(sort_text)
	design_levels()
	
	var parcel_types = initial_parcel_counts.keys()
	var all_parcels = {}
	for type in parcel_types:
		all_parcels[type] = range(initial_parcel_counts[type])
	for day_i in range(1,day+1):
		parcel_numbers_to_make = []
		for type in parcel_types:
			for parcel_i in range(level_parcels[type][day_i-1]):
				var random_choice = random_generator.randi_range(0,len(all_parcels[type])-1)
				parcel_numbers_to_make.append([type,all_parcels[type].pop_at(random_choice)])
	parcel_numbers_to_make.shuffle()
	total_parcels = len(parcel_numbers_to_make)
	global_start_pos = sorters[0]["start_pos"]

	parcel_scene = load("res://parcel.tscn")
	bird_scene = load("res://bird.tscn")


	
func design_levels():
	for child in get_node("level design").get_children():
		if child is level_component:
			var child_name = child.get_name()
			var name_components = child_name.split("-")
			if day >= int(name_components[0]) and name_components[2] == "start":
				var terminal
				var end_node = get_node("level design/" + name_components[0] + "-" + name_components[1] + "-end")
				if day == int(name_components[0]):
					terminal = true
				else:
					terminal = false
				add_sorter(child.position, end_node.position,terminal,int(name_components[0]))
	sorters.sort_custom(sorter_sort)

	

func get_direction(spinner, parcel):
	var index = parcel.sorters.find(spinner.sorter)
	if index >= 0:
		var destination = parcel.sorters[index + 1]["start_pos"]
		return destination
	return 'random'
	
func explode():
	if game_over:
		return
	game_over = true
	Sfx.play(preload("res://sfx/explosion.ogg"))

	var explosion_scene = load("res://explosion.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.level = day
	add_child(explosion)
	print("exploded succesfully")
	
func win():
	if game_over:
		return
	game_over = true
	var win_scene = load("res://sorted.tscn")
	var sorted = win_scene.instantiate()
	Sfx.play(preload('res://sfx/win.wav'))
	sorted.level = day
	sorted.game_time = day_timer
	add_child(sorted)

func _input(event):
	if !game_over:
		if event.is_action_pressed("escape"):
			game_over = true
			metagame.transition(self, "level_select",{})
		elif event.is_action_pressed("restart"):
			game_over = true
			metagame.transition(self, "game_loop",{"day":day})
func create_parcel():
	var total_sorters = len(sorters)
	var parcel = parcel_scene.instantiate()
	var parcel_number = parcel_numbers_to_make.pop_front()
	parcel.number = parcel_number 
	parcels.append(parcel)
	parcel.day = day
	parcel.game_loop = self
	var parcel_sorters = [sorters[0]]
	var last_sorter_number = 0
	while !parcel_sorters[-1]["terminal"]:
		last_sorter_number = random_generator2.randi_range(last_sorter_number + 1,len(sorters)-1)
		parcel_sorters.append(sorters[last_sorter_number])
	var bird = bird_scene.instantiate()
	bird.position = Vector2(global_start_pos.x,1500)
	bird_on_the_way = true
	bird.game = self
	parcel.bird = bird
	parcel.parcel_mode = "bird"
	parcel.start_pos = global_start_pos
	add_child(bird)
	add_child(parcel)
	parcel.sorters = parcel_sorters

func _draw():
	return
	draw_circle(sorters[-1]["start_pos"], 6.0, Color.RED)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	day_timer += delta

	if game_over:
		get_node("timer").count_up = false
	var parcel_at_spawn = false
	var done_parcels = 0
	for parcel in parcels:
		if parcel.parcel_mode == "done":
			done_parcels += 1
		if (parcel.position-global_start_pos).length() < 50:
			parcel_at_spawn = true
	sort_count.get_node("RichTextLabel").text = "[center]"+	str(total_parcels-done_parcels)+ "[/center]"
	if done_parcels == total_parcels and day_timer > 5:
		any_rejected = false
		for parcel in sorted_parcels:
			if parcel.rejected:
				any_rejected = true
		if !any_rejected:
			win()
	if len(parcel_numbers_to_make)>0 and !parcel_at_spawn and !bird_on_the_way and global_start_pos:
		create_parcel()
		spawned_parcels += 1
	
