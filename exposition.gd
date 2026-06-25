extends Node2D

var text_number =1 
var destination_scene
var destination_data
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = load("res://ui_button.tscn")
	var animater = get_node("AnimatedSprite2D")
	animater.play('default')
	animater.set_frame_and_progress(text_number,0)
	animater.pause()
	var play = button.instantiate()
	play.button_type = "play"
	play.button_destination_scene = destination_scene
	play.button_destination_data = destination_data
	play.position = Vector2(550,580)
	add_child(play)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
