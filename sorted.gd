extends TextureRect

var timer = 0
var game_time
var level
var metagame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	metagame = get_tree().root.get_node("meta_game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 2:
		timer = -10000
		if level > len(metagame.level_completion):
			metagame.level_completion.append(3)
		if level == 6:
			metagame.transition(self.get_parent(), "exposition",{"number":6,"scene":"post_level","data":{"day":level,"time":game_time}})
		else:
			metagame.transition(self.get_parent(), "post_level",{"day":level,"time":game_time})
