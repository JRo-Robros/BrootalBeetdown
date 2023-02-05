extends Node2D


func _ready():
	$WaveSpawner.connect('wave_finished', self, "next_phase")


func next_phase():
	print('next phase')
	$WaveSpawner.start_wave()
