extends KinematicBody2D

export var speed = 6000


func _ready():
	print("ready!")


func _physics_process(delta):
	move_and_slide(Vector2(0, speed) * delta)
	
	if position.y > 1500:
		queue_free()
