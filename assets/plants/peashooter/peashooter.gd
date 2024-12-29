extends Plant
class_name PeaShooter

enum TYPE {
	NORMAL,
	SNOW,
	FIRE
}

@export var shootingType:TYPE = TYPE.NORMAL

@export var maxShootingTimer:int = 2
@export var sight:Area2D
@export var marker:Marker2D

@export var shootingPlayer:AnimationPlayer

var shootingTimer:float = maxShootingTimer
var can_shoot:bool = false

var peaScene = preload("res://assets/objects/peas/normal/pea.tscn")

func _process(delta):
	can_shoot = false
	if (sight.has_overlapping_areas()):
		can_shoot = true
	if activated:
		shootingTimer -= delta
		if can_shoot:
			if shootingTimer <= 0:
				shootingTimer = maxShootingTimer
				shootingPlayer.play("shoot")

func shoot():
	var pea = peaScene.instantiate()
	pea.change_type(shootingType)
	Global.mainScene.add_child(pea)
	pea.global_position = marker.global_position
