extends Node2D

onready var wave_message = $CanvasLayer/CenterContainer/Announcements

func _ready():
	$WaveSpawner.connect('wave_started', self, "wave_started")
	$WaveSpawner.connect('wave_finished', self, "wave_finished")


func wave_finished():
	print('next phase')
	wave_message.text = ""
	$WaveSpawner.start_wave()

func wave_started():
	wave_message.text = "Get ready for the next wave..."
