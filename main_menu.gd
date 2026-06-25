extends Node2D

var metagame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	metagame = get_tree().root.get_node("meta_game")

	var button = load("res://ui_button.tscn")
	var title_scene = load("res://title.tscn")
	var sorter_scene = load("res://menu_hedgehog.tscn")
	var parcel_scene = load("res://menu_parcel.tscn")
	var title = title_scene.instantiate()
	var sorter = sorter_scene.instantiate()
	var parcel = parcel_scene.instantiate()
	sorter.parcel = parcel
	parcel.hedgehog = sorter
	var levels = button.instantiate()
	var play = button.instantiate()
	levels.button_type = "level_select"
	play.button_type = "play"
	play.button_destination = min(len(metagame.level_completion)+1,6)
	levels.position = Vector2(400,350)
	play.position = Vector2(750,350)
	sorter.position = Vector2(750,550)
	parcel.position = Vector2(900,550)
	add_child(levels)
	add_child(title)
	add_child(sorter)
	add_child(parcel)
	add_child(play)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
