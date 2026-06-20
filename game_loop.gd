extends Node2D
var spinner_scene
var conveyer_scene
var destination_scene
var day = 2
var sorters = []

func add_sorter(start_pos,end_pos,terminal):
	sorters.append({})
	var conveyer = conveyer_scene.instantiate()
	conveyer.start_pos = start_pos
	conveyer.end_pos = end_pos
	conveyer.on_creation()
	end_pos = conveyer.end_pos
	add_child(conveyer)
	sorters[-1]["conveyer"] = conveyer
	if terminal:
		var destination = destination_scene.instantiate()
		destination.position = end_pos
		conveyer.endpoint = destination
		add_child(destination)
		sorters[-1]["destination"] = destination
		
	else:
		var spinner = spinner_scene.instantiate()
		spinner.game_loop = self
		spinner.position = end_pos
		conveyer.endpoint = spinner
		add_child(spinner)
		sorters[-1]["spinner"] = spinner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spinner_scene = load("res://spinner.tscn")
	conveyer_scene = load("res://conveyer.tscn")
	destination_scene = load("res://destination.tscn")
	design_levels()
	var parcel = load("res://parcel.tscn")
	var parcel1 = parcel.instantiate()
	var parcel2 = parcel.instantiate()
	parcel1.position = Vector2(100,100)
	parcel2.position = Vector2(150,100)
	add_child(parcel1)
	add_child(parcel2)
	
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
				add_sorter(child.position, end_node.position,terminal)
					
func get_direction(spinner, parcel):
	return 'random'
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
