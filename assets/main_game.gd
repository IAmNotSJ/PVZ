extends Node2D

@onready var tilemap = $World/TileMap
@onready var cursor = $Cursor

var peaShooterScene = load('res://assets/plants/peashooter/peashooter.tscn')
var sunFlowerScene = load('res://assets/plants/sunflower/sunflower.tscn')
var evilSunFlowerScene = load('res://assets/plants/evil_sunflower/evil_sunflower.tscn')
var walNutScene = load('res://assets/plants/walnut/walnut.tscn')

var zombieScene = load("res://assets/zombies/base/zombie.tscn")
var sunScene = load("res://assets/objects/sun/sun.tscn")
var curHolding
var tileOffset:Vector2 = Vector2(45, 45)

var shovel_active = false;

var sun:int = 0

var sunTimer:float = 10
var zombieTimer:float = 15

var rng = RandomNumberGenerator.new()

func _on_packet_1_pressed():
	hold_plant($"HUD/Seed Packets/Packet 1".plant)
func _on_packet_2_pressed():
	hold_plant($"HUD/Seed Packets/Packet 2".plant)
func _on_packet_3_pressed():
	hold_plant($"HUD/Seed Packets/Packet 3".plant)

func _ready():
	collect_sun(50)

func _process(delta):
	zombieTimer -= delta
	if (zombieTimer <= 0):
		spawn_zombie()
		zombieTimer = 15
	
	sunTimer -= delta
	if (sunTimer <= 0):
		spawn_sun()
		sunTimer = 10
	
	if (curHolding != null):
		curHolding.position = get_global_mouse_position()
	if Input.is_action_just_pressed("cancel"):
		cancel_planting()
	
	if shovel_active:
		if Input.is_action_just_pressed("click") and tilemap.dic.has(str(tilemap.curTile)):
			if "cost" in tilemap.dic[str(tilemap.curTile)]:
				tilemap.dic[str(tilemap.curTile)].remove_plant()
			print(tilemap.dic[str(tilemap.curTile)])
	
	if Input.is_action_just_pressed("sun"):
		collect_sun(25)
	
	if Input.is_action_just_pressed("plant") and curHolding != null:
		plant_plant(curHolding)

func cancel_planting():
	if (curHolding != null):
		curHolding.queue_free()
	curHolding = null

func collect_sun(amount:int = 25):
	sun += amount
	$"HUD/Sun Counter".text = str(sun)

func subtract_sun(amount:int):
	sun -= amount
	$"HUD/Sun Counter".text = str(sun)

func spawn_zombie():
	var zombie = zombieScene.instantiate()
	
	zombie.global_position = Vector2(1170, (rng.randi_range(0, 4) * tilemap.cell_quadrant_size) + tilemap.global_position.y)
	print(zombie.global_position)
	add_child(zombie)

func spawn_sun():
	var sun_instance = sunScene.instantiate()
	sun_instance.global_position = Vector2(rng.randi_range(100, 1052), -30)
	add_child(sun_instance)

func hold_plant(plant):
	if curHolding == null:
		var plant_to_hold 
		match plant:
			'peashooter':
				plant_to_hold = peaShooterScene.instantiate()
			'sunflower':
				plant_to_hold = sunFlowerScene.instantiate()
			'walnut':
				plant_to_hold = walNutScene.instantiate()
			'evil_sunflower':
				plant_to_hold = evilSunFlowerScene.instantiate()
		if (sun < plant_to_hold.cost):
			plant_to_hold.queue_free()
			pass
		curHolding = plant_to_hold
		plant_to_hold.apply_dark()
		curHolding.global_position = get_global_mouse_position()
		add_child(plant_to_hold)
	else:
		plant_plant(curHolding)

func plant_plant(plant):
	if (sun >= plant.cost and tilemap.dic.has(str(tilemap.curTile))):
		
		if check_tile_availability():
			subtract_sun(curHolding.cost)
			
			$"Sound Effects/Planting Sound".play()
			plant.global_position = tilemap.curTile * tilemap.cell_quadrant_size + tileOffset + tilemap.global_position
			tilemap.dic[str(tilemap.curTile)] = plant
			plant.curTile = tilemap.curTile
			plant.activate()
			print('plant planted!')
			plant.z_index = 0
			
			curHolding = null
			
			plant.reset_shaders()
	else:
		cancel_planting()

func remove_plant(plant):
	plant.queue_free()
	tilemap.dic[str(plant.curTile)] = "Free"

func check_tile_availability():
	if !"cost" in tilemap.dic[str(tilemap.curTile)] and tilemap.dic[str(tilemap.curTile)] == "Free":
		return true
	else:
		return false
