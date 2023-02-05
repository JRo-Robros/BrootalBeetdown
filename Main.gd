extends Node2D

enum STATE {GET_READY, ACTIVE, COUNTDOWN, COOLDOWN}

var waves = 3
onready var wave_message = $CanvasLayer/CenterContainer/Announcements
onready var wave_spawner = $YSort/Tom/WaveSpawner

func _ready():
	wave_spawner.connect('wave_state_changed', self, "on_wave_state_changed")


func on_wave_state_changed():
	print(wave_spawner.state)
	match wave_spawner.state:
		0:
			wave_message.text = "Get Ready for the next wave !!"

		1:
			wave_message.text = ""

		2:
			wave_message.text = "Almost there..."

		3:
			wave_message.text = "Phew!"
			
		_:
			wave_message.text = ""
			print("waves ", waves)
			if waves > 1:
				waves -= 1
				wave_spawner.start_wave(wave_spawner.spawn_amount + 1, wave_spawner.spawn_time * 0.8)
			else:
				wave_message.text = "Time for a BEETDOWN!!"
				pass
#				spawn boss fight
			


func _on_Tom_player_died():
	print('deds')
	wave_message.text = "You DIED!!!!"
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://Main.tscn")
