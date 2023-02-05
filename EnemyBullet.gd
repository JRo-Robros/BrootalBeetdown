extends KinematicBody2D


var damage = 1
var speed: int = 25
var direction:Vector2 = Vector2.ZERO


func _process(delta):
	$Sprite.rotation_degrees += 1
	var collision = move_and_collide(direction * speed)
	if collision:
		if collision.collider.has_method('take_damage'):
			collision.collider.take_damage(damage)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
