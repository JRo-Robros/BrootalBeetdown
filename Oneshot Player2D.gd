extends AudioStreamPlayer2D



func _on_Oneshot_Player2D_finished():
	queue_free()
