extends Node2D

var cooldown = 0.5
var in_cooldown = false
var bullet = preload("res://EnemyBullet.tscn")


func _process(delta):
	if in_cooldown:
		return
	var b = bullet.instance()
	b.direction = Vector2.UP
	b.position = position
	get_parent().add_child_below_node(self, b)
	in_cooldown = true
	$Timer.start(cooldown)
	return


func _on_Timer_timeout():
	in_cooldown = false
	return
