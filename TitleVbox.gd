extends VBoxContainer

export var seperation = 70


func _ready():
	add_constant_override("separation", seperation)
