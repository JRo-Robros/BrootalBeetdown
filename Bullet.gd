class_name player_bullet
extends KinematicBody2D


var damage = 1
var speed: int = 25
var direction:Vector2 = Vector2.ZERO


func _process(delta):
	move_and_collide(direction * speed)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
