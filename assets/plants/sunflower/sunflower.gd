extends Plant
class_name Sunflower

var sunScene = load("res://assets/objects/sun/sun.tscn")

const maxProductionTimer:int = 24
var productionTimer:float = randi_range(4,8)

func _process(delta):
	if activated:
		productionTimer -= delta
		if productionTimer <= 0:
			productionTimer = maxProductionTimer
			$AnimationPlayer.play("sun")

func produce_sun():
	print('sun produced!')
	var sun = sunScene.instantiate()
	sun.global_position = $"Limbs/Head and Face/Head/sun_anchor".global_position
	sun.from_sky = false
	global.mainScene.add_child(sun)
