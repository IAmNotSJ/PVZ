extends Node2D

@onready var tilemap = $World/TileMap
@onready var cursor = $Cursor

@onready var cam_position:Vector2 = Vector2($Cam.position)

@onready var packet1Scene = load($"HUD/Seed Packets/Packet 1".plantPath)
@onready var packet2Scene = load($"HUD/Seed Packets/Packet 2".plantPath)
@onready var packet3Scene = load($"HUD/Seed Packets/Packet 3".plantPath)
@onready var packet4Scene = load($"HUD/Seed Packets/Packet 4".plantPath)

signal plant_planted

enum {
	START,
	DIALOGUE,
	MOVE_CAMERA,
	GAME
}

var zombieScene = load("res://assets/zombies/base/zombie.tscn")
var sunScene = load("res://assets/objects/sun/sun.tscn")

func _on_packet_1_clicked():
	hold_plant(1)
func _on_packet_2_clicked():
	hold_plant(2)
func _on_packet_3_clicked():
	hold_plant(3)
func _on_packet_4_clicked():
	hold_plant(4)

var state = START

var cam_timer:float
var game_started:bool = false

var curHolding
var tileOffset:Vector2 = Vector2(45, 45)

var shovel_active = false;

var sun:int = 0

var sunTimer:float = 10
var zombieTimer:float = 15

var rng = RandomNumberGenerator.new()

func _ready():
	collect_sun(50)

func _process(delta):
	match state:
		START:
			start_state()
		DIALOGUE:
			pass
		MOVE_CAMERA:
			move_camera_state(delta)
		GAME:
			game_state(delta)

func start_state():
	cam_timer = 17
	cam_position.x += 300
	
	state = MOVE_CAMERA

func move_camera_state(delta):
	if Input.is_action_just_pressed("space"):
		cam_timer = 0
		@warning_ignore("integer_division")
		$Cam.position.x = 1152/2
		@warning_ignore("integer_division")
		cam_position.x = 1152/2
		state = GAME
	$Cam.position = $Cam.position.move_toward(cam_position, 50 * delta)
	
	cam_timer -= delta
	print(cam_timer)
	
	if (cam_timer <= 8):
		@warning_ignore("integer_division")
		cam_position.x = 1152/2
	if (cam_timer <= 0):
		game_started = true
		state = GAME

func game_state(delta):
		zombieTimer -= delta
		if (zombieTimer <= 0):
			spawn_zombie()
			zombieTimer = 15
		
		if Input.is_action_just_pressed("spawn_zombie"):
			spawn_zombie()
		
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

func hold_plant(packet):
	if game_started:
		if curHolding == null:
			var plant_to_hold 
			match packet:
				1:
					plant_to_hold = packet1Scene.instantiate()
				2:
					plant_to_hold = packet2Scene.instantiate()
				3:
					plant_to_hold = packet3Scene.instantiate()
				4:
					plant_to_hold = packet4Scene.instantiate()
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
			plant.reset_shaders()
			
			curHolding = null
			
			plant_planted.emit(plant)
	else:
		cancel_planting()

func remove_plant(plant):
	plant.queue_free()
	tilemap.dic[str(plant.curTile)] = "Free"

func check_tile_availability():
	print(tilemap.dic[str(tilemap.curTile)])
	if !"cost" in tilemap.dic[str(tilemap.curTile)] and tilemap.dic[str(tilemap.curTile)] == "Free":
		return true
	else:
		return false
