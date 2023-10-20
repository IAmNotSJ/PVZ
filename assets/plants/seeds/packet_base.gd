extends Button

@export var plant = ''

func _ready():
	if (plant != ''):
		icon = load("res://assets/plants/seeds/packet_" + plant + ".png")
	else:
		icon = load("res://assets/plants/seeds/packet_unknown.png")
