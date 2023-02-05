extends Node2D

signal wave_started
signal wave_finished

enum STATE {GET_READY, ACTIVE, COUNTDOWN, COOLDOWN}

export var spawn_amount = 4
export var spawn_time = 2.0
export var wave_time = 20

var state = STATE.GET_READY
var enemy = preload("res://Enemy 1.tscn")
var rand = RandomNumberGenerator.new()
onready var wave_timer = $Timer
onready var rect_size = get_viewport_rect().size


func _ready():
	rand.randomize()
	start_wave()


func start_wave(_sp_amt = 4, _sp_time = 2.0, _wv_time = 20):
	spawn_amount = _sp_amt
	spawn_time = _sp_time
	wave_time = _wv_time
	state = STATE.GET_READY
	wave_timer.start(3)
	emit_signal("wave_started")
	
func _on_Timer_timeout():
	match state:
		STATE.GET_READY:
			print('to active')
			state = STATE.ACTIVE
			_on_SpawnTimer_timeout()
			wave_timer.start(wave_time)
		STATE.ACTIVE:
			print('to countdown')
			state = STATE.COUNTDOWN
			wave_timer.start(10)
		STATE.COUNTDOWN:
			print('to_cooldown')
			state = STATE.COOLDOWN
			wave_timer.start(5)
			emit_signal('wave_finished')
		STATE.COOLDOWN:
			pass


func _on_SpawnTimer_timeout():
	if state == STATE.COOLDOWN:
		return
	var enemies_node = get_parent().get_node('YSort')
	for i in spawn_amount:
		var e = enemy.instance()
		var n = rand.randf()
		e.position = rect_size
		match rand.randi_range(1,4):
			1:
				e.position.y = e.position.y * n
			2:
				e.position.y = e.position.y * n
				e.position.x = 0
			3:
				e.position.x = e.position.x * n
			4:
				e.position.x = e.position.x * n
				e.position.y = 0
		e.position.x -= rect_size.x / 2
		enemies_node.add_child(e)
	if state == STATE.ACTIVE or state == STATE.COUNTDOWN:
		$SpawnTimer.start(spawn_time)
		
