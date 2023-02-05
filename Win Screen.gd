extends Node2D


onready var object = preload("res://Faller.tscn")


func _on_Return_to_Title_button_up():
	get_tree().change_scene("res://Title.tscn")


func spawn_faller():
	var faller = object.instance()
	faller.position = Vector2(rand_range(0, 6000), -50)
	get_tree().current_scene.add_child(faller)




func _on_Spawn_Timer_timeout():
	spawn_faller()
