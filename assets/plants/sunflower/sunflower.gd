extends Plant
class_name Sunflower

var sunScene = load("res://assets/objects/sun/sun.tscn")

const maxProductionTimer:int = 24
var productionTimer:float = rng.randi_range(4,8)

func _process(delta):
	if activated:
		productionTimer -= delta
		if productionTimer <= 0:
			productionTimer = maxProductionTimer
			$AnimationPlayer.play("sun")

func dance(anim = idleAnim):
	$AnimationPlayer.play(anim)
	
	super()

func activate():
	$hurtbox.collision_layer = 2
	print('extended node code running')
	
	super()

func produce_sun():
	print('sun produced!')
	var sun = sunScene.instantiate()
	sun.global_position = $sun_anchor.position
	sun.from_sky = false
	add_child(sun)
