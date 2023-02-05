extends Light2D


var decay = 5

func _physics_process(delta):
	energy = max(energy - decay * delta, 0)
	
	if energy <= 0:
		queue_free()
