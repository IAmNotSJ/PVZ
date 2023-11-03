extends Control

@onready var mainScene = get_tree().current_scene

@onready var shovel_position = $Shovel.global_position

var packets = []

func _ready():
	packets = [$"Seed Packets/Packet 1", $"Seed Packets/Packet 2", $"Seed Packets/Packet 3", $"Seed Packets/Packet 4"]
func _process(_delta):
	if mainScene.game_started:
		if ($Shovel/hitbox.has_overlapping_areas() && Input.is_action_just_pressed("click")):
			if (mainScene.shovel_active != true):
				mainScene.shovel_active = true
			else:
				$Shovel.global_position = shovel_position
				mainScene.shovel_active = false
		if (mainScene.shovel_active):
			$Shovel.global_position = mainScene.cursor.global_position


func _on_main_game_plant_planted(plant):
	print('hihi')
	
	for i in 4:
		if packets[i].plant == plant.plant_name:
			packets[i].activate_cooldown()
