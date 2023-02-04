extends RigidBody2D


var vine_speed = 20
var rooted = false
var vine_in_motion = false
var health = 10
var target: Vector2 = Vector2.INF

onready var vine = $Vine
onready var vine_text = $Vine/TextureRect


func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
		if event.button_index == BUTTON_RIGHT and event.pressed:
			print("Right button was clicked at ", event.position)
			target = event.position
			vine_in_motion = true


func _process(delta):
	vine.look_at(get_global_mouse_position())
	if vine_in_motion && target != Vector2.INF:
		vine_text.rect_size.x += vine_speed
		if vine_text.rect_size.x >= abs(position.distance_to(target)):
			vine_text.rect_size.x = 50
			target = Vector2.INF
			vine_in_motion = false
			
