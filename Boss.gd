extends KinematicBody2D

enum STATE {SEEKING, IDLE, SHOOTING}
var state = STATE.SEEKING


export var max_speed = 500
export var acceleration = 2000
export var deceleration = 2000
export var health = 100
export var bullet_angle = 0 # degrees
export var bullet_spread = 30 #degrees

export var hurt_sound = preload("res://Sound Effects/Enemy/Enemy hit sound.mp3")
export var shoot_sound = preload("res://Sound Effects/Player/Player shoot sound.mp3")
export var bullet = preload("res://EnemyBullet.tscn")

var aggro = false
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

onready var bullet_spawner = $"Bullet Spawner"
onready var sprite = $Sprite
onready var init_spawner_pos = bullet_spawner.position
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
	$AnimationPlayer.play("Default")


func _physics_process(delta):
	match_state()
	move(delta)
	flip_sprite()



func match_state():
	match state:
		STATE.SEEKING:
			if Globals.player:
				direction = Vector2(1, 0).rotated(get_angle_to(Globals.player.position))
			
			$"State Timer".wait_time = 3
		
		STATE.IDLE:
			direction = Vector2.ZERO
			$"State Timer".wait_time = 5
		
		
		STATE.SHOOTING:
			direction = Vector2.ZERO
			$"State Timer".wait_time = 2
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
			$Visual.scale.x = -1
			bullet_spawner.position.x = -init_spawner_pos.x
			bullet_angle = 0
		else:
			$Visual.scale.x = 1
			bullet_spawner.position.x = init_spawner_pos.x
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
	shoot_sound()


func shoot_sound():
	var audio = load("res://Oneshot Player2D.tscn").instance()
	audio.stream = shoot_sound
	audio.pitch_scale = rand.randf_range(0.7, 0.9)
	audio.position = position
	audio.play()
	get_tree().current_scene.add_child(audio)


func _on_Fire_Rate_timeout():
	match state:
		STATE.SHOOTING:
			shoot()


func take_damage(damage):
	health -= damage
	$ColorRect.margin_right = health * 3
	if health <= 50:
		$ColorRect.color = Color.yellow
	if health <= 30:
		aggro = true
	if health <= 0:
		death()



func _on_State_Timer_timeout():
	match state:
		STATE.IDLE:
			state = STATE.SEEKING
		
		STATE.SEEKING:
			state = STATE.SHOOTING
		
		STATE.SHOOTING:
			state = STATE.IDLE
		
func death():
	queue_free()
