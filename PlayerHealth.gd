extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("player_health_changed", self, 'update_health')


func update_health():
	if Globals.player:
		margin_right = Globals.player.health * 4 - 400
		if Globals.player.health < 20:
			modulate = Color.orangered
			return
		if Globals.player.health < 55:
			modulate = Color.goldenrod
			return
		modulate = Color.greenyellow
		return
