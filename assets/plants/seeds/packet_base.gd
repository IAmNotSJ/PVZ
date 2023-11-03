extends Control

signal clicked

@export var plant = ''
@export var plantPath = ''

@onready var plantRef = load(plantPath)

var clickable:bool = false
var on_cooldown:bool = false

var max_cooldown:float = 5
var cooldown:float = max_cooldown

func _process(delta):
	if clickable and Input.is_action_just_pressed("click") and !on_cooldown:
		clicked.emit()
	
	if on_cooldown:
		cooldown -= delta
		$CooldownBox.size.y -= $Packet.texture.get_height() / max_cooldown * delta
		if cooldown <= 0:
			on_cooldown = false
			cooldown = max_cooldown

func _ready():
	if (plant != ''):
		$Packet.texture = load("res://assets/plants/seeds/packet_" + plant + ".png")
		$CooldownBox/DarkPacket.texture = load("res://assets/plants/seeds/packet_" + plant + ".png")
	else:
		$Packet.texture = load("res://assets/plants/seeds/packet_unknown.png")
		$CooldownBox/DarkPacket.texture = load("res://assets/plants/seeds/packet_" + plant + ".png")

func activate_cooldown():
	on_cooldown = true
	$CooldownBox.size.y = $Packet.texture.get_height()
	print('yo')

func _on_mouse_entered():
	clickable = true

func _on_mouse_exited():
	clickable = false
