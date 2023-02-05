extends Sprite

var time = 0
var amplitude = 30
var frequency = 1

func _process(delta):
	time += delta
	var movement = cos(time * frequency) * amplitude
	position.y += movement * delta
