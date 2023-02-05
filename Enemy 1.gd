class_name mob
extends KinematicBody2D

enum STATE {SEEKING, IDLE}
var state = STATE.SEEKING
var state_list = [STATE.SEEKING, STATE.IDLE]
onready var state_timer = $"State Timer"

export var random_state = true
export var max_speed = 300
export var max_speed_random = 60
export var acceleration = 2000
export var deceleration = 2000
export var damage = 5

export var hurt_sound = preload("res://Sound Effects/Enemy/Enemy hit sound.mp3")

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
	max_speed += rand.randf_range(-max_speed_random, max_speed_random)
	
	set_random_state()
	$AnimationPlayer.play('default')

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
	var audio = load("res://Oneshot Player2D.tscn").instance()
	audio.stream = hurt_sound
	audio.pitch_scale = rand_range(0.9,1.1)
	audio.position = global_position
	audio.play()
	get_tree().current_scene.add_child(audio)
	queue_free()


func set_random_state():
	if random_state:
		state = state_list[rand.randi_range(0,state_list.size() - 1)]


func _on_State_Timer_timeout():
	set_random_state()
	state_timer.start(rand.randf_range(0.5,1.5))
