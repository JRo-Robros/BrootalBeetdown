extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_health()
	Globals.connect("player_health_changed", self, 'update_health')


func update_health():
	if Globals.player:
		text = String(Globals.player.health)
