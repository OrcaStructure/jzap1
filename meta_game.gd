extends Node2D
var save_path = "user://save.json"
var main_menu_scene
var level_select_scene
var post_level_scene
var level_completion = []
var transition_scene
var press_any_key
var main_menu
var transition_timer = 0
var transition_from
var transition_node
var transition_to
var game_loop_scene
var transition_stage = 0
var transition_data
var exposition_scene
var pbs = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(ProjectSettings.globalize_path("user://"))
	load_game()
	var global_controls_scene = load("res://global_controls.tscn")
	var global_controls = global_controls_scene.instantiate()
	var press_any_key_scene = load("res://press_key.tscn")
	add_child(global_controls)
	main_menu_scene = load("res://main_menu.tscn")
	level_select_scene =  load("res://level_select.tscn")
	transition_scene = load('res://transition.tscn')
	post_level_scene = load("res://level_end_ui.tscn")
	game_loop_scene = load("res://game_loop.tscn")
	exposition_scene = load("res://exposition.tscn")
	press_any_key = press_any_key_scene.instantiate()
	add_child(press_any_key)
func create_main_menu():
	if is_instance_valid(press_any_key):
		press_any_key.queue_free()
	main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
	Sfx.	music_player.play()
	Sfx.music_player.seek(5)
	
func transition(scene_from, scene_to,data):
	transition_stage = 0
	transition_timer = 0
	if (scene_from.get_name() == "game_loop" and scene_to != "game_loop") or (scene_from.get_name() != "game_loop" and scene_to == "game_loop"):
		Sfx.on_music_finished() 
	print("destroy_transition_time")
	if is_instance_valid(transition_node):
		transition_node.queue_free()
	transition_stage = 1
	transition_from = scene_from
	transition_to = scene_to
	transition_node = transition_scene.instantiate()
	add_child(transition_node)
	transition_data = data

func save_game():
	var save_data = {
		"pbs": pbs,
		"level_completion": level_completion
	}
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	if not FileAccess.file_exists(save_path):
		return {}
	var load_data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	pbs = load_data["pbs"]
	level_completion = load_data["level_completion"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transition_stage > 0:
		transition_timer += delta
	if transition_timer > 1 and transition_stage == 1:
		if is_instance_valid(transition_from):
			transition_from.queue_free()
		transition_stage = 2
		if transition_to == "post_level":
			var post_level = post_level_scene.instantiate()
			post_level.day = transition_data["day"]
			post_level.time = transition_data["time"]
			add_child(post_level)
		elif transition_to == "game_loop":
			var game_loop = game_loop_scene.instantiate()
			game_loop.day = transition_data["day"]
			add_child(game_loop)
		elif transition_to == "level_select":
			var level_select = level_select_scene.instantiate()
			level_select.level_completion = level_completion
			add_child(level_select)
		elif transition_to == "exposition":
			var exposition = exposition_scene.instantiate()
			exposition.destination_scene = transition_data["scene"]
			exposition.destination_data = transition_data["data"]
			exposition.text_number = transition_data["number"]
			add_child(exposition)
	if transition_timer > 3:
		transition_stage = 0
		transition_timer = 0
		print("destroy_transition_time")
		if is_instance_valid(transition_node):
			transition_node.queue_free()
				
