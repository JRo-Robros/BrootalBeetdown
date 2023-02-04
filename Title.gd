extends Node2D





func _on_Start_button_up():
	$Music.stop()
	get_tree().change_scene("res://Main.tscn")
