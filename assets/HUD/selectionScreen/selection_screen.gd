extends Node2D

@onready var HUD = get_parent().get_parent()

const packetScene = preload("res://assets/plants/seeds/packet_base.tscn")

var packets = []

func _ready():
	for i  in range(Plants.plants.keys().size()):
		var plant_name = Plants.plants.keys()[i]
		var packet = packetScene.instantiate()
		packet.plant = Plants.plants.keys()[i]
		packet.plantPath = Plants.plants[plant_name]["Path"]
		packet.add_price(Plants.plants[plant_name]["Price"])
		packet.add_sprite()
		packet.position = Vector2(14 + i * 75, 145)
		packet.intended_pos = packet.global_position
		packets.append(packet)
		add_child(packet)

func packet_clicked(packet):
	if packet.picked:
		remove_packet(packet)
	else:
		add_packet(packet)

func add_packet(packet):
	HUD.packets.append(packet)
	reposition_selected()
	packet.reparent(HUD.seedPackets)
	packet.picked = true

func remove_packet(packet):
	HUD.packets.erase(packet)
	packet.intended_pos = Vector2(14 + HUD.plantList.find(packet.plant) * 75, 145)
	reposition_selected()
	packet.reparent(HUD.selectionScreen)
	packet.picked = false

func reposition_selected():
	for i in range(HUD.packets.size()):
		HUD.packets[i].intended_pos = Vector2(i * 75, 0)
