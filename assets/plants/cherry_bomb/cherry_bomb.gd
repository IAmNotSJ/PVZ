extends Plant
class_name CherryBomb
@export var MAX_EXPLOSION_TIMER = 2

var explosion_timer = MAX_EXPLOSION_TIMER

func activate():
	print('HI???')
	$AnimationPlayer.play('wind up')
	
	super()

func explode():
	print('splodin')
	#$ExplosionRadius.collision_layer = 4
	if ($ExplosionRadius.has_overlapping_areas()):
		for i in $ExplosionRadius.get_overlapping_areas().size():
			$ExplosionRadius.get_overlapping_areas()[i].owner.take_damage(30)
	remove_plant()
