extends Node2D





func _on_Start_button_up():
	$Music.stop()
	get_tree().change_scene("res://Main.tscn")


func _on_Quit_button_up():
	get_tree().quit()
