extends Area2D

var button_type
var button_destination_scene = false
var button_destination_data
var animater
var played = false
var metagame
var button_destination = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_pickable = true
	input_event.connect(_on_input_event)
	animater = get_node("AnimatedSprite2D")
	animater.play(button_type)
	animater.pause()
	metagame = get_tree().root.get_node("meta_game")
	

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !played:
			Sfx.play(preload("res://sfx/click.wav"))
			played = true
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if button_type == "play" and button_destination > 0:
				metagame.transition(self.get_parent(),"exposition",{"number":button_destination-1,"scene":"game_loop","data":{"day":button_destination}})
			elif button_type == "play" and typeof(button_destination_data) != typeof(false):
				metagame.transition(self.get_parent(),button_destination_scene, button_destination_data)
			elif button_type == "level_select":
				metagame.transition(self.get_parent(), "level_select",{})
			elif button_type == "replay":
				metagame.transition(self.get_parent(), "game_loop",{"day":button_destination-1})
			elif button_type == "next_level":
				metagame.transition(self.get_parent(),"exposition",{"number":button_destination-1,"scene":"game_loop","data":{"day":button_destination}})
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered():
	animater.set_frame_and_progress(1,0)
	
func _on_mouse_exited():
	animater.set_frame_and_progress(0,0)
