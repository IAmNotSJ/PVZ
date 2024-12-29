class_name Plant extends Node2D

@export var plant_name:String

@export var cost:int
@export var max_health:int
@export var max_cooldown:int = 5

@export var shaderPlayer: Node
@export var animationPlayer: Node

@export var hitbox: Area2D
@export var bottom:Marker2D

@export var idleAnim = 'idle'

var health = max_health
var activated:bool = false

var curTile:Vector2

var rng = RandomNumberGenerator.new()

func _process(_delta):
	if activated:
		pass

func dance(_anim = idleAnim):
	if _anim != null:
		animationPlayer.play(_anim)

func activate():
	health = max_health
	if hitbox != null:
		hitbox.collision_layer = 2
	activated = true
	dance()

func take_damage(amount:float):
	health -= amount
	apply_blink()
	
	if health <= 0:
		remove_plant()

func remove_plant():
	queue_free()
	Global.mainScene.tilemap.dic[str(curTile)] = "Free"

func fake_remove_plant():
	visible = false
	activated = false

func reset_shaders():
	shaderPlayer.play("RESET")

func apply_dark():
	shaderPlayer.play("darken")

func apply_blink():
	shaderPlayer.play("blink")
