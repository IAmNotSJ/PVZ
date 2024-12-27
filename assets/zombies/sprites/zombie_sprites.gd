class_name ZombieSprites extends Node2D

@onready var parent = get_parent()

@onready var animationPlayer = $AnimationPlayer
var stage:int = 0

func _ready():
	parent.hurt.connect(parent_hurt)
func step():
	parent.step()

func parent_hurt(_amount):
	var hp = parent.health
	print(hp)
	if hp <= 0:
		parent.queue_free()
	elif hp <= 3:
		change_stage(1)

func change_stage(da_stage:int):
	match da_stage:
		1:
			if (stage < 1):
				stage = 1
				$"Arm 1/Bottom Sleeve".visible = false
				$"Arm 1/Hand".visible = false
				$"Arm 1/Fake Arm/AnimationPlayer".play('fall')
