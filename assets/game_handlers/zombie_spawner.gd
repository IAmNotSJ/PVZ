extends Node

@onready var game = get_parent()

@onready var zombieTimer = $ZombieTimer

enum TYPES {
	NORMAL,
	CONE,
	BUCKET,
	NEIGHBOR
}

var zombieScenes:Dictionary = {
	"Normal" : "res://assets/zombies/base/zombie.tscn",
	"Cone" : "res://assets/zombies/cone/zombie.tscn",
	"Bucket" : "res://assets/zombies/cone/zombie.tscn",
	"Neighbor" : "res://assets/zombies/neighbor/zombie.tscn"
}

var zombieFile:JSON
var zombieList:Array = [
	[[TYPES.NORMAL, 0]],
	[],
	[[TYPES.NORMAL, 2]],
	[],
	[],
	[[TYPES.CONE, 3]],
	[[TYPES.BUCKET, 4]]
]

func _ready():
	game.started.connect(zombieTimer.start)

func _unhandled_input(event):
	if event.is_action_pressed("spawn_zombie"):
		spawn_zombie(TYPES.BUCKET, randi_range(0,4))


func spawn_zombie(type:TYPES, lane:int):
	var zombScene
	match type:
		TYPES.NORMAL, TYPES.CONE, TYPES.BUCKET:
			zombScene = zombieScenes["Normal"]
		TYPES.NEIGHBOR:
			zombScene = zombieScenes["Neighbor"]
	
	var zombie = load(zombScene).instantiate()
	match type:
		TYPES.CONE:
			await get_tree().process_frame
			zombie.add_hat(zombie.Hat.CONE)
		TYPES.BUCKET:
			await get_tree().process_frame
			zombie.add_hat(zombie.Hat.BUCKET)
	zombie.global_position = Vector2(1170, (lane * game.tilemap.cell_quadrant_size) + game.tilemap.global_position.y + 60)
	
	game.add_child(zombie)


func _on_timer_timeout():
	for i in range(zombieList[0].size()):
		spawn_zombie(zombieList[0][i][0], zombieList[0][i][1])
	zombieList.remove_at(0)
	zombieTimer.wait_time = 5
	if zombieList == []:
		zombieTimer.stop()
