class_name Chomper extends Plant

@onready var sight = $Sight

enum {
	IDLE,
	BITING,
	CHEW,
	SWALLOW
}
var state = IDLE

const attack:int = 50

func _process(_delta):
	if activated:
		match state:
			IDLE:
				if sight.get_overlapping_areas() != []:
					$AnimationPlayer.play('bite')
					state = BITING
			BITING:
				if !$AnimationPlayer.is_playing():
					state = CHEW
					$AnimationPlayer.play('chew')
					$ChewTimer.start()
			SWALLOW:
				if !$AnimationPlayer.is_playing():
					state = IDLE
					$AnimationPlayer.play(idleAnim)

func bite():
	sight.get_overlapping_areas()[0].owner.take_damage(attack, Enums.DAMAGE_PHYSICAL)


func _on_chew_timer_timeout():
	print('timeout!')
	state = SWALLOW
	$AnimationPlayer.play('swallow')
