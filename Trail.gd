extends CPUParticles2D

func _ready():
	if "direction" in get_parent():
		direction = get_parent().direction
