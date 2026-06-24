extends TextureRect

var timer = 0
var level
var metagame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	metagame = get_tree().root.get_node("meta_game")
	print("Hello?")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 2:
		metagame.transition(self.get_parent(), "game_loop",{"day":level})
		timer = -10000
