extends Camera2D


var rand = RandomNumberGenerator.new()
var shaking = false


# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	Globals.cam = self


func start_shake():
	shaking = true
	yield(get_tree().create_timer(0.3), "timeout")
	stop_shake()


func stop_shake():
	zoom = Vector2.ONE
	shaking = false
	

func _process(_delta):
	if !shaking:
		return
	var r = (rand.randf() - 0.5) * 0.1
	zoom = Vector2.ONE + Vector2(r,r)
	
