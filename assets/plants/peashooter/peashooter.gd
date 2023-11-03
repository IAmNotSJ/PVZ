extends Plant
class_name PeaShooter

const maxShootingTimer:int = 2

var shootingTimer:float = maxShootingTimer
var can_shoot:bool = false

var peaScene = load('res://assets/plants/peashooter/pea.tscn')

func _process(delta):
	can_shoot = false
	if ($hitbox.has_overlapping_areas()):
		can_shoot = true
	if activated:
		shootingTimer -= delta
		if can_shoot:
			if shootingTimer <= 0:
				shootingTimer = maxShootingTimer
				$ShootingPlayer.play("shoot")

func shoot():
	var pea = peaScene.instantiate()
	mainScene.add_child(pea)
	pea.global_position = $Marker2D.global_position

func dance(anim = idleAnim):
	$AnimationPlayer.play(anim)
	
	super()

func activate():
	$hurtbox.collision_layer = 2
	
	super()

