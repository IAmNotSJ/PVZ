extends Control

signal clicked

@export var plant = ''
@export var plantPath = ''

@onready var plantRef
@onready var max_cooldown:float
@onready var cooldown:float

const movement_speed:float = 35

var intended_pos:Vector2 = position

var cost:int = 0

var clickable:bool = false
var on_cooldown:bool = false

var picked:bool = false

func add_sprite():
	if (plant != ''):
		$Packet.texture = load("res://assets/plants/seeds/packet_" + plant + ".png")
		$CooldownBox/DarkPacket.texture = load("res://assets/plants/seeds/packet_" + plant + ".png")
	else:
		$Packet.texture = load("res://assets/plants/seeds/packet_unknown.png")
		$CooldownBox/DarkPacket.texture = load("res://assets/plants/seeds/packet_" + plant + ".png")

func add_special():
	if plantPath != null:
		plantRef = load(plantPath).instantiate()
		max_cooldown = plantRef.max_cooldown
		cooldown = max_cooldown
		#$CooldownBox.set_deferred("size.x", $Packet.texture.get_width)

func add_price(price):
	cost = price
	$RichTextLabel.text = str(cost)

func _process(delta):
	if clickable and Input.is_action_just_pressed("click") and !on_cooldown:
		clicked.emit()
	if clickable and Input.is_action_just_pressed("cancel"):
		cooldown = 0
		$CooldownBox.size.y = 0
	if on_cooldown:
		cooldown -= delta
		$CooldownBox.size.y -= $Packet.texture.get_height() / max_cooldown * delta
		if cooldown <= 0:
			on_cooldown = false
			cooldown = max_cooldown
	position = lerp(position, intended_pos, delta * movement_speed)

func activate_cooldown():
	on_cooldown = true
	$CooldownBox.size.y = $Packet.texture.get_height()

func _on_mouse_entered():
	clickable = true

func _on_mouse_exited():
	clickable = false
