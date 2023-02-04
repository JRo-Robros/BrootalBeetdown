extends KinematicBody2D
enum STATE {UNROOTED, VINE_IN_MOTION, TOM_IN_MOTION, ROOTED}

export var vine_speed: float = 0.8
export var tom_speed: int = 6
export var health: int = 100
export var cooldown:float = 0.15

export var shoot_sound = preload("res://Sound Effects/Player/Player shoot sound.mp3")
export var hurt_sound = preload("res://Sound Effects/Player/Player hit sound.mp3")
export var vine_sound = preload("res://Sound Effects/Player/vine.mp3")

var in_cooldown = false
var state = STATE.UNROOTED
var rooted = false
var vine_in_motion = false
var tom_in_motion = false
var vine_target: Vector2 = Vector2.INF
var tom_target: Vector2 = position
var bullet = preload("res://Bullet.tscn")

onready var vine = $Vine
onready var vine_text = $Vine/TextureRect
onready var crosshair = $Crosshair


func _ready():
	Globals.player = self
	return


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			vine_target = event.position
			vine_text.rect_size.x = abs(position.distance_to(vine_target)) * 0.8
			state = STATE.VINE_IN_MOTION
			play_vine_sound()


func _process(delta):
	crosshair.look_at(get_global_mouse_position())
	match state:
		STATE.UNROOTED, STATE.ROOTED:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				shoot(get_global_mouse_position() - position)
			vine.visible = false
			crosshair.visible = true
			vine.look_at(get_global_mouse_position())
			if vine_target != Vector2.INF:
				state = STATE.VINE_IN_MOTION
			continue
			
		STATE.VINE_IN_MOTION, STATE.TOM_IN_MOTION:
			vine.visible = true
			crosshair.visible = false
			if vine_target != Vector2.INF:
				vine.look_at(vine_target)
			continue
			
			
		STATE.UNROOTED:
				pass
				
		STATE.VINE_IN_MOTION:
			if vine_text.rect_size.x <= abs(position.distance_to(vine_target)) - 50:
				vine_text.rect_size.x = lerp(vine_text.rect_size.x, abs(position.distance_to(vine_target)), vine_speed)
			else:
				tom_target = vine_target
				vine_text.rect_size.x = 10
				vine_target = Vector2.INF
				state = STATE.TOM_IN_MOTION
				
		STATE.TOM_IN_MOTION:
			if position.distance_squared_to(tom_target) <= 50:
				position = tom_target
				state = STATE.ROOTED
			else:
				var collision = move_and_collide((tom_target - position) * delta * tom_speed)
				vine_text.rect_size.x = abs(position.distance_to(tom_target))
				if collision:
					state = STATE.ROOTED
					
		STATE.ROOTED:
			vine.look_at(get_global_mouse_position())
			if vine_target != Vector2.INF:
				vine_text.rect_size.x = 10
				state = STATE.VINE_IN_MOTION




func shoot(direction):
	if in_cooldown:
		return
	var b = bullet.instance()
	b.direction = direction.normalized()
	b.position = position
	get_parent().add_child_below_node(self, b)
	play_shoot_sound()
	in_cooldown = true
	$BulletTimer.start(cooldown)
	return



func _on_BulletTimer_timeout():
	in_cooldown = false
	return


func take_damage(damage):
	health -= damage
	play_hurt_sound()
	Globals.emit_signal("player_health_changed")


#sound functions
func play_shoot_sound():
	var audio = load("res://Oneshot Player2D.tscn").instance()
	audio.stream = shoot_sound
	audio.pitch_scale = rand_range(1.1,1.2)
	audio.position = global_position
	audio.play()
	get_tree().current_scene.add_child(audio)


func play_hurt_sound():
	var audio = load("res://Oneshot Player2D.tscn").instance()
	audio.stream = hurt_sound
	audio.pitch_scale = rand_range(0.9,1.1)
	audio.position = global_position
	audio.play()
	get_tree().current_scene.add_child(audio)


func play_vine_sound():
	var audio = load("res://Oneshot Player2D.tscn").instance()
	audio.stream = vine_sound
	audio.pitch_scale = rand_range(0.9,1.1)
	audio.position = global_position
	audio.play()
	get_tree().current_scene.add_child(audio)
