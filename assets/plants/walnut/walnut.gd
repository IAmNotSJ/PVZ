extends Plant

func activate():
	$hurtbox.collision_layer = 2
	
	super()

func dance(anim = idleAnim):
	$AnimationPlayer.play(anim)
	
	super()

func take_damage(amount:float):
	health -= amount
	$ShaderPlayer.play("blink")
	
	if health <= 0:
		remove_plant()
	elif health <= 10:
		dance("stage 3")
	elif health <= 30:
		dance("stage 2")


func remove_plant():
	queue_free()
	mainScene.tilemap.dic[str(curTile)] = "Free"

func apply_dark():
	$"ShaderPlayer".play("darken")
func reset_shaders():
	$"ShaderPlayer".play("RESET")
