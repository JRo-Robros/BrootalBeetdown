extends RigidBody2D


var rooted = false
var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
		if event.button_index == BUTTON_RIGHT and event.pressed:
			print("Right button was clicked at ", event.position)
