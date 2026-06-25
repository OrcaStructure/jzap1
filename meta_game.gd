extends Node2D

var main_menu_scene
var level_select_scene
var post_level_scene
var level_completion = [3,2,3,3]
var transition_scene
var main_menu
var transition_timer = 0
var transition_from
var transition_node
var transition_to
var game_loop_scene
var transition_stage = 0
var transition_data
var exposition_scene
var pbs = [1000,1000,1000,1000,1000]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_scene = load("res://main_menu.tscn")
	level_select_scene =  load("res://level_select.tscn")
	transition_scene = load('res://transition.tscn')
	post_level_scene = load("res://level_end_ui.tscn")
	game_loop_scene = load("res://game_loop.tscn")
	exposition_scene = load("res://exposition.tscn")
	main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
	
func transition(scene_from, scene_to,data):
	transition_stage = 0
	transition_timer = 0
	print("destroy_transition_time")
	if is_instance_valid(transition_node):
		transition_node.queue_free()
	transition_stage = 1
	transition_from = scene_from
	transition_to = scene_to
	transition_node = transition_scene.instantiate()
	add_child(transition_node)
	transition_data = data
	
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
				
