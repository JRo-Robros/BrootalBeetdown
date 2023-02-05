extends Node2D

signal wave_state_changed

enum STATE {GET_READY, ACTIVE, COUNTDOWN, COOLDOWN}

export var spawn_amount = 4
export var spawn_time = 1.2
export var wave_time = 15.0

var state = null
var enemy = preload("res://Enemy 1.tscn")
var rand = RandomNumberGenerator.new()
onready var wave_timer = $Timer
onready var rect_size = get_viewport_rect().size * 1.2


func _ready():
	rand.randomize()
	start_wave()


func start_wave(_sp_amt = 4, _sp_time = 1.2, _wv_time = 15.0):
	spawn_amount = _sp_amt
	spawn_time = _sp_time
	wave_time = _wv_time
	state = STATE.GET_READY
	emit_signal('wave_state_changed')
	wave_timer.start(3)
	
func _on_Timer_timeout():
	var new_state = null
	match state:
		STATE.GET_READY:
			new_state = STATE.ACTIVE
			_on_SpawnTimer_timeout()
			wave_timer.start(wave_time)
		STATE.ACTIVE:
			new_state = STATE.COUNTDOWN
			wave_timer.start(5)
		STATE.COUNTDOWN:
			new_state = STATE.COOLDOWN
			wave_timer.start(7)
	state = new_state
	emit_signal('wave_state_changed')


func _on_SpawnTimer_timeout():
	$SpawnTimer.start(spawn_time)
	if state == STATE.COOLDOWN or state == STATE.GET_READY or state == null:
		return
	var enemies_node = get_parent().get_parent()
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
