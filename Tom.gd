extends KinematicBody2D
enum STATE {UNROOTED, VINE_IN_MOTION, TOM_IN_MOTION, ROOTED}

export var vine_speed: float = 0.4
export var tom_speed: int = 6

var state = STATE.UNROOTED
var rooted = false
var vine_in_motion = false
var tom_in_motion = false
var health = 10
var vine_target: Vector2 = Vector2.INF
var tom_target: Vector2 = position

onready var vine = $Vine
onready var vine_text = $Vine/TextureRect


func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			# Handle firing logic
			pass
		if event.button_index == BUTTON_RIGHT and event.pressed:
			if state != STATE.VINE_IN_MOTION:
				# Only allow vine target setting if vine is not already extending
				vine_target = event.position
				vine_text.rect_size.x = abs(position.distance_to(vine_target)) / 2

func _process(delta):
	match state:
		STATE.UNROOTED, STATE.ROOTED:
			vine.visible = false
			vine.look_at(get_global_mouse_position())
			if vine_target != Vector2.INF:
				state = STATE.VINE_IN_MOTION
			continue
			
		STATE.VINE_IN_MOTION, STATE.TOM_IN_MOTION:
			vine.visible = true
			if vine_target != Vector2.INF:
				vine.look_at(vine_target)
			continue
			
			
		STATE.UNROOTED:
				pass
				
		STATE.VINE_IN_MOTION:
			if vine_text.rect_size.x <= abs(position.distance_to(vine_target)) - 10:
				vine_text.rect_size.x = lerp(vine_text.rect_size.x, abs(position.distance_to(vine_target)), vine_speed)
			else:
				tom_target = vine_target
				vine_text.rect_size.x = 10
				vine_target = Vector2.INF
				state = STATE.TOM_IN_MOTION
				
		STATE.TOM_IN_MOTION:
			if position.distance_squared_to(tom_target) <= 10:
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

