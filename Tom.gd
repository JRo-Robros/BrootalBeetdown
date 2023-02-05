extends KinematicBody2D
enum STATE {UNROOTED, VINE_IN_MOTION, TOM_IN_MOTION, ROOTED}

signal player_died

export var vine_speed: float = 0.8
export var tom_speed: int = 6
export var health: int = 100
export var base_cooldown:float = 0.04

export var shoot_sound = preload("res://Sound Effects/Player/Player shoot sound.mp3")
export var hurt_sound = preload("res://Sound Effects/Player/Player hit sound.mp3")
export var vine_sound = preload("res://Sound Effects/Player/vine.mp3")
export var lock_sound = preload("res://Sound Effects/Player/Player lock sound.mp3")
export var gun_particles = preload("res://VFX/Gun Particles.tscn")

var dead = false
var cooldown:float = base_cooldown
var in_cooldown = false
var state = STATE.UNROOTED
var rooted = false
var vine_in_motion = false
var tom_in_motion = false
var vine_target: Vector2 = Vector2.INF
var tom_target: Vector2 = position
var bullet = preload("res://Bullet.tscn")
var hurt_tex = preload("res://GraphicalAssets/hurt1.png")
var def_tex = preload("res://GraphicalAssets/angry.png")
var shock_tex = preload("res://GraphicalAssets/shock.png")

onready var vine = $Vine
onready var vine_text = $Vine/TextureRect
onready var crosshair = $Crosshair


func _ready():
	Globals.player = self
	$AnimationPlayer.play('Default')
	return


func _input(event):
	if dead:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			vine_target = get_global_mouse_position()
			vine_text.rect_size.x = abs(position.distance_to(vine_target)) * 0.8
			state = STATE.VINE_IN_MOTION
			play_vine_sound()


func _process(delta):
	if dead:
		return
	if cooldown >= 0.35:
		$Visual/Polygon2D.texture = shock_tex
		
	var mouse_loc = get_global_mouse_position()
	crosshair.look_at(mouse_loc)
	$Visual.scale.x = -1 if mouse_loc.x < position.x else 1
		
	match state:
		STATE.UNROOTED, STATE.ROOTED:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				shoot(mouse_loc - position)
			crosshair.visible = true
			vine.look_at(mouse_loc)
			if vine_target != Vector2.INF:
				state = STATE.VINE_IN_MOTION
			continue
			
		STATE.VINE_IN_MOTION, STATE.TOM_IN_MOTION:
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
				cooldown = base_cooldown
				$Visual/Polygon2D.texture = def_tex
				
		STATE.TOM_IN_MOTION:
			if position.distance_squared_to(tom_target) <= 50:
				position = tom_target
				play_lock_sound()
				state = STATE.ROOTED
			else:
				var collision = move_and_collide((tom_target - position) * delta * tom_speed)
				vine_text.rect_size.x = abs(position.distance_to(tom_target))
				if collision:
					play_lock_sound()
					vine_text.rect_size.x = 10
					state = STATE.ROOTED
					
		STATE.ROOTED:
			vine.look_at(mouse_loc)
			if vine_target != Vector2.INF:
				vine_text.rect_size.x = 10
				state = STATE.VINE_IN_MOTION




func shoot(direction):
	if in_cooldown:
		return
	cooldown *= 1.09
	var b = bullet.instance()
	b.direction = direction.normalized()
	b.position = position
	get_parent().add_child_below_node(self, b)
	play_shoot_sound()
	gun_particles()
	in_cooldown = true
	$BulletTimer.start(cooldown)
	return



func _on_BulletTimer_timeout():
	in_cooldown = false
	return


func take_damage(damage):
	health -= damage
	play_hurt_sound()
	if health <= 0:
		player_death()
	Globals.emit_signal("player_health_changed")
	$Visual/Polygon2D.texture = hurt_tex

func gun_particles():
	var particles = gun_particles.instance()
	particles.global_position = position + Vector2(90, 0).rotated(get_angle_to((get_global_mouse_position())))
	particles.rotation = crosshair.rotation
	particles.z_index = z_index + 1
	particles.emitting = true
	get_tree().current_scene.add_child(particles)


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


func play_lock_sound():
	var audio = load("res://Oneshot Player2D.tscn").instance()
	audio.stream = lock_sound
	audio.pitch_scale = rand_range(0.95,1.05)
	audio.position = global_position
	audio.play()
	get_tree().current_scene.add_child(audio)


func player_death():
	dead = true
	$AnimationPlayer.play("Death")


func inform_player_dead():
	emit_signal("player_died")
