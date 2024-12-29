extends Control

const packetScene = preload("res://assets/plants/seeds/packet_base.tscn")

@onready var shovel_position = $Shovel.global_position

@onready var packetHolder = $"Packet Holder"
@onready var seedPackets = $"Packet Holder/Seed Packets"

@onready var selectionScreen = %SelectionScreen

var plantsToAdd:Array = [
	["peashooter", "res://assets/plants/peashooter/peashooter.tscn"],
	["sunflower", "res://assets/plants/sunflower/sunflower.tscn"],
	["walnut", "res://assets/plants/walnut/walnut.tscn"],
	["potato_mine", "res://assets/plants/potato_mine/potato_mine.tscn"],
	["snow_pea", "res://assets/plants/snow_pea/snow_pea.tscn"],
	["cherry_bomb", "res://assets/plants/cherry_bomb/cherry_bomb.tscn"]
]

var plantList:Array = [
	"peashooter","sunflower","walnut","potato_mine","snow_pea","cherry_bomb","chomper"
]
var packets = []

var packet_count = 6

func _process(_delta):
	if global.mainScene.game_started:
		if ($Shovel/hitbox.has_overlapping_areas() && Input.is_action_just_pressed("click")):
			if (global.mainScene.shovel_active != true):
				global.mainScene.shovel_active = true
			else:
				$Shovel.global_position = shovel_position
				global.mainScene.shovel_active = false
		if (global.mainScene.shovel_active):
			$Shovel.global_position = global.mainScene.cursor.global_position


func _on_main_game_plant_planted(plant):
	print('hihi')
	
	for i in packet_count:
		if packets[i].plant == plant.plant_name:
			packets[i].activate_cooldown()
