extends Plant
class_name PotatoMine

@export var max_draw_time = 13


enum {
	HIDING,
	DEPLOYED
}
var state = HIDING

var draw_time = max_draw_time

func dance(anim = idleAnim):
	$AnimationPlayer.play(anim)
	
	super()

func activate():
	super()

func _process(delta):
	if activated:
		match state:
			HIDING:
				draw_time -= delta
				print('DRAW TIME:' + str(draw_time))
				if draw_time <= 0:
					state = DEPLOYED
					$AnimationPlayer.play('deployed')
					print('deployed')
			DEPLOYED:
				if ($DetectionRange.has_overlapping_areas()):
					for i in $ExplosionRadius.get_overlapping_areas().size():
						$ExplosionRadius.get_overlapping_areas()[i].owner.take_damage(30)
						remove_plant()
