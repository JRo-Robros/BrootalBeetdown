extends Node2D

export var element_count = 100

onready var images = [
preload("res://GraphicalAssets/environment/elements-01.png"), 
preload("res://GraphicalAssets/environment/elements-02.png"),
preload("res://GraphicalAssets/environment/elements-03.png"),
preload("res://GraphicalAssets/environment/elements-04.png"),
preload("res://GraphicalAssets/environment/elements-05.png"),
preload("res://GraphicalAssets/environment/elements-06.png"),
preload("res://GraphicalAssets/environment/elements-07.png"),
preload("res://GraphicalAssets/environment/elements-08.png"),
preload("res://GraphicalAssets/environment/elements-09.png"),
]

onready var rand = RandomNumberGenerator.new()

func _ready():
	for object in element_count:
		rand.randomize()
		var element = preload("res://element.tscn").instance()
		element.position = Vector2(rand.randi_range(-1600, 2265), rand.randi_range(-600, 1785))
		element.texture = images[rand.randi_range(0,8)]
		add_child(element)
