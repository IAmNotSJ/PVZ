extends Plant
class_name PotatoMine

@export var max_draw_time = 13

@export var sight:Area2D

var can_explode = false
var despawn_timer:float = 1

enum {
	HIDING,
	DEPLOYING,
	DEPLOYED
}
var state = HIDING

var draw_time = max_draw_time

func _process(delta):
	if can_explode:
		global.mainScene.cam.shake_screen(delta, 2, 1)
		despawn_timer -= delta
		
		if (despawn_timer <= 0):
			remove_plant()
	if activated:
		match state:
			HIDING:
				hiding_state(delta)
			DEPLOYING:
				deploying_state()
			DEPLOYED:
				deployed_state()

func hiding_state(delta):
	draw_time -= delta
	if draw_time <= 0:
		state = DEPLOYING
		$AnimationPlayer.play('deploying')

func deploying_state():
	pass

func deployed_state():
	if (sight.has_overlapping_areas()):
		can_explode = true
		for i in sight.get_overlapping_areas().size():
			sight.get_overlapping_areas()[i].owner.take_damage(30, Enums.DAMAGE_EXPLOSION)
			fake_remove_plant()

func change_to_deployed():
	state = DEPLOYED
	$AnimationPlayer.play('deployed')
	$BeepPlayer.play('beep')
