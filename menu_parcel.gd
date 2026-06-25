extends Area2D
var mouse_click_position
var hedgehog
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input_event(viewport,event, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			hedgehog.mode = "dragging"
			hedgehog.animater.play("default")
			mouse_click_position = get_global_mouse_position()
		else:
			if not mouse_click_position:	
				mouse_click_position = get_global_mouse_position()

			hedgehog.mode = "default"
			rotation = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
