extends Node2D
var spinner_scene
var conveyer_scene
var parcel_scene
var destination_scene
var day = 2
var sorted_parcels = []
var sorters = []
var total_parcels = 30
var spawned_parcels = 0
var day_timer = 0 
var parcels = []

func sorter_sort(a,b):
	return a["day"] < b["day"]
	
func add_sorter(start_pos,end_pos,terminal,day):
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
	spinner_scene = load("res://spinner.tscn")
	conveyer_scene = load("res://conveyer.tscn")
	destination_scene = load("res://destination.tscn")
	design_levels()
	parcel_scene = load("res://parcel.tscn")

	
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
	print(index)
	if index >= 0:
		var destination = parcel.sorters[index + 1]["start_pos"]
		return destination
	return 'random'
	
func create_parcel():
	var total_sorters = len(sorters)
	var parcel = parcel_scene.instantiate()
	parcels.append(parcel)
	var parcel_sorters = [sorters[0]]
	var last_sorter_number = 0
	while !parcel_sorters[-1]["terminal"]:
		last_sorter_number = randi_range(last_sorter_number + 1,len(sorters)-1)
		parcel_sorters.append(sorters[last_sorter_number])
	parcel.position = sorters[0]["start_pos"]
	add_child(parcel)
	parcel.sorters = parcel_sorters

func _draw():
	draw_circle(sorters[-1]["start_pos"], 6.0, Color.RED)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	day_timer += delta
	if day_timer > 3* spawned_parcels and spawned_parcels < total_parcels:
		create_parcel()
		spawned_parcels += 1
