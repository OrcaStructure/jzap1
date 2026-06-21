extends RichTextLabel

var fade = "in"
var times = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate.a = 0

func show_text():
	fade = "in"
	times = 3
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if times > 0:
		if fade == "in" and self_modulate.a < 1:
			self_modulate.a = min(1,self_modulate.a + delta * 10)
		elif fade == "out" and self_modulate.a > 0:
			self_modulate.a = max(0,self_modulate.a - delta * 10)
		elif self_modulate.a == 1:
			fade = "out"
		elif self_modulate.a == 0:
			fade = "in"
			times -= 1
