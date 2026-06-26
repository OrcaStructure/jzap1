extends Node2D

var rectangles = []
var rectangle_numbers = ["1","2","3","4","5"]
var times = [0.4,0.2,0.3,0.5,0.1]
var directions = []
var killed_sounds = false
var rectangle_speed = 1600
var timer = 0
var wait_time = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for number in rectangle_numbers:
		var rectangle = get_node(number)
		rectangles.append(rectangle)
		var direction = -1
		if rectangle.position.y < 322:
			direction = 1
		directions.append(direction)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	for i in range(5):
		if timer > times[i]:
			if !killed_sounds:
				Sfx.clear_active()
				killed_sounds = true

			var rectangle = rectangles[i]
			var direction =directions[i]
			var new_y = rectangle.position.y + rectangle_speed * direction * delta
			if (new_y - 322) * direction < 0 or timer > 1 + times[i]:
				rectangle.position.y = new_y
			else:
				rectangle.position.y = 322
	
