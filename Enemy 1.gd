extends KinematicBody2D

enum STATE {SEEKING, IDLE}
var state = STATE.SEEKING


export var max_speed = 300
export var acceleration = 2000
export var deceleration = 2000
export var damage = 1

var direction = Vector2.ZERO
var velocity = Vector2.ZERO


func _physics_process(delta):
	set_direction()
	move(delta)


func set_direction():
	match state:
		STATE.SEEKING:
			if Globals.player:
				direction = Vector2(1, 0).rotated(get_angle_to(Globals.player.position))
		
		STATE.IDLE:
			direction = Vector2.ZERO


func move(delta):
	if direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	else:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	if(area.get_parent().has_method('take_damage')):
		area.get_parent().take_damage(damage)
		queue_free()


func take_damage(damage):
	queue_free()
