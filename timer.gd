extends Node2D

var time = 0.0
var count_up = false
var text_node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_node = get_node("RichTextLabel") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if count_up:
		time += delta
	text_node.text = "[center]{"+	str(roundi(float(time)))+ "}[/center]"

	

		
