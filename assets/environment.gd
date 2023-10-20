extends Node2D

var sunScene = load("res://assets/objects/sun/sun.tscn")

var sun:int = 0
var sunTimer:float = 3

var rng = RandomNumberGenerator.new()

func _process(delta):
	sunTimer -= delta
	if (sunTimer <= 0):
		spawn_sun()
		sunTimer = 3
	
	if Input.is_action_just_pressed("sun"):
		collect_sun(25)

func collect_sun(amount:int = 25):
	sun += amount
	$"HUD/Sun Counter".text = str(sun)

func subtract_sun(amount:int):
	sun -= amount
	$"HUD/Sun Counter".text = str(sun)

func spawn_sun():
	print('sun spawned!')
	var sun = sunScene.instantiate()
	sun.global_position = Vector2(rng.randi_range(0, 1280), -30)
	add_child(sun)
