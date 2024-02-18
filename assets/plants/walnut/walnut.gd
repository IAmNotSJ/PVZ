extends Plant

func take_damage(amount:float):
	health -= amount
	$ShaderPlayer.play("blink")
	print(health)
	
	if health <= 0:
		remove_plant()
	elif health <= 10:
		dance("stage 3")
	elif health <= 30:
		dance("stage 2")
		print('doi')


func remove_plant():
	queue_free()
	Global.mainScene.tilemap.dic[str(curTile)] = "Free"

func apply_dark():
	$"ShaderPlayer".play("darken")
func reset_shaders():
	$"ShaderPlayer".play("RESET")
