extends Area2D

var button_type
var animater
var metagame
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
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if button_type == "play":
				metagame.transition(self.get_parent(),"post_level",{"day":2,"time":145})
			elif button_type == "level_select":
				metagame.transition(self.get_parent(), "level_select",{})
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered():
	animater.set_frame_and_progress(1,0)
	
func _on_mouse_exited():
	animater.set_frame_and_progress(0,0)
