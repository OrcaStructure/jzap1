extends Area2D

var type
var day
var level_select = false
var text_node
var timer = 0
var completion_time
var animater
var metagame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	input_pickable = true
	metagame = get_tree().root.get_node("meta_game")
	
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	animater = get_node("AnimatedSprite2D")
	text_node = get_node("RichTextLabel")
	text_node.text = "[center]"+str(day)+"[/center]"

	if type == -2:
		animater.play("lock")
		text_node.text = "[center]"+"[/center]"

	elif type == -1:
		animater.play("ready")
	else:
		animater.play("stars")
		animater.pause()
		animater.set_frame_and_progress(0,0)

func _on_mouse_entered():
	if level_select:
		if type >= 0:
			animater.play("hover")
			animater.pause()
			animater.set_frame_and_progress(type,0)
		elif type == -1:
			animater.play("ready_hover")
			
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			metagame.transition(self.get_parent(),"exposition",{"number":day-1,"scene":"game_loop","data":{"day":day}})

	
func _on_mouse_exited():
	if level_select:
		if type >= 0:
			animater.play("stars")
			animater.pause()
			animater.set_frame_and_progress(type,0)
		elif type == -1:
			animater.play("ready")

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if animater.frame < type and timer > float(animater.frame)/2 + 0.5:
		animater.frame += 1
