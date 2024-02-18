extends Node2D

@onready var HUD = get_parent()

const packetScene = preload("res://assets/plants/seeds/packet_base.tscn")

var packet_list:Array = [
	["peashooter", "res://assets/plants/peashooter/peashooter.tscn"],
	["sunflower", "res://assets/plants/sunflower/sunflower.tscn"],
	["walnut", "res://assets/plants/walnut/walnut.tscn"],
	["potato_mine", "res://assets/plants/potato_mine/potato_mine.tscn"],
	["snow_pea", "res://assets/plants/snow_pea/snow_pea.tscn"],
	["cherry_bomb", "res://assets/plants/cherry_bomb/cherry_bomb.tscn"]
]

#TODO: FIND BETTER WAY TO FUCKING DO THIS
var plantPrices:Array = [
	100, 50, 50, 25, 150, 150
]

var packets = []

func _ready():
	for i  in range(packet_list.size()):
		var packet = packetScene.instantiate()
		packet.plant = packet_list[i][0]
		packet.plantPath = packet_list[i][1]
		packet.add_price(plantPrices[i])
		packet.add_sprite()
		packet.position = Vector2(14 + i * 75, 145)
		packets.append(packet)
		add_child(packet)

func packet_clicked(packet):
	if packet.picked:
		remove_packet(packet)
	else:
		add_packet(packet)

func add_packet(packet):
	HUD.packets.append(packet)
	packet.reparent(HUD.seedPackets)
	reposition_selected()
	packet.picked = true

func remove_packet(packet):
	HUD.packets.erase(packet)
	packet.reparent(HUD.selectionScreen)
	print(HUD.plantList.find(packet.plant))
	packet.position = Vector2(14 + HUD.plantList.find(packet.plant) * 75, 145)
	reposition_selected()
	packet.picked = false

func reposition_selected():
	for i in range(HUD.packets.size()):
		HUD.packets[i].position = Vector2(165 + i * 75, 5 )
