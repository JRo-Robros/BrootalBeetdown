extends KinematicBody2D

enum STATE {SEEKING, IDLE, SHOOTING}
var state = STATE.SHOOTING


export var max_speed = 500
export var acceleration = 2000
export var deceleration = 2000
export var damage = 5
export var bullet_angle = 0 # degrees
export var bullet_spread = 30 #degrees

export var hurt_sound = preload("res://Sound Effects/Enemy/Enemy hit sound.mp3")
export var bullet = preload("res://Bullet.tscn")

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

onready var bullet_spawner = $"Bullet Spawner"
onready var sprite = $Sprite
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()


func _physics_process(delta):
	match_state()
	move(delta)
	flip_sprite()



func match_state():
	match state:
		STATE.SEEKING:
			if Globals.player:
				direction = Vector2(1, 0).rotated(get_angle_to(Globals.player.position))
		
		STATE.IDLE:
			direction = Vector2.ZERO
		
		
		STATE.SHOOTING:
			direction = Vector2.ZERO
			pass


func move(delta):
	if direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	else:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	
	velocity = move_and_slide(velocity)


func flip_sprite():
	if Globals.player:
		if Globals.player.position.x > position.x:
			sprite.flip_h = true
			bullet_angle = 0
		else:
			sprite.flip_h = false
			bullet_angle = 180


func shoot():
	var inst = bullet.instance()
	inst.position = bullet_spawner.global_position
	if Globals.player:
		inst.rotation = get_angle_to(Globals.player.position) + deg2rad(rand.randf_range(-bullet_spread, bullet_spread))
	inst.position  = bullet_spawner.global_position
	if "speed" in inst and "direction" in inst:
		inst.speed = 15
		inst.direction = Vector2(1,0).rotated(inst.rotation)
	get_tree().current_scene.add_child(inst)



func _on_Fire_Rate_timeout():
	match state:
		STATE.SHOOTING:
			shoot()




func _on_State_Timer_timeout():
	match state:
		STATE.IDLE:
			state = STATE.SEEKING
		
		STATE.SEEKING:
			state = STATE.SHOOTING
		
		STATE.SHOOTING:
			state = STATE.IDLE
		
