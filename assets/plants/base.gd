class_name Plant extends Node2D

@onready var mainScene = get_tree().current_scene

@export var plant_name:String

@export var cost:int
@export var max_health:int

@export var shaderPlayer: Node
@export var animationPlayer: Node

@export var idleAnim = 'idle'

var health = max_health
var activated:bool = false

var curTile:Vector2

var rng = RandomNumberGenerator.new()

func _process(_delta):
	if activated:
		pass

func dance(_anim = idleAnim):
	pass

func activate():
	health = max_health
	dance()
	activated = true

func take_damage(amount:float):
	health -= amount
	apply_blink()
	
	if health <= 0:
		remove_plant()

func remove_plant():
	queue_free()
	mainScene.tilemap.dic[str(curTile)] = "Free"

func reset_shaders():
	shaderPlayer.play("RESET")

func apply_dark():
	shaderPlayer.play("darken")

func apply_blink():
	shaderPlayer.play("blink")
