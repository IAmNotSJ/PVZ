extends Control

@onready var mainScene = get_tree().current_scene

@onready var shovel_position = $Shovel.global_position

func _process(_delta):
	if ($Shovel/hitbox.has_overlapping_areas() && Input.is_action_just_pressed("click")):
		if (mainScene.shovel_active != true):
			mainScene.shovel_active = true
		else:
			$Shovel.global_position = shovel_position
			mainScene.shovel_active = false
	if (mainScene.shovel_active):
		$Shovel.global_position = mainScene.cursor.global_position
