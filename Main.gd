extends Node2D

enum STATE {GET_READY, ACTIVE, COUNTDOWN, COOLDOWN}

var waves = 3
onready var wave_message = $CanvasLayer/CenterContainer/Announcements

func _ready():
	$WaveSpawner.connect('wave_state_changed', self, "on_wave_state_changed")


func on_wave_state_changed():
	print($WaveSpawner.state)
	match $WaveSpawner.state:
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
				$WaveSpawner.start_wave($WaveSpawner.spawn_amount + 1, $WaveSpawner.spawn_time * 0.8)
			else:
				wave_message.text = "Time for a BEETDOWN!!"
				pass
#				spawn boss fight
			
