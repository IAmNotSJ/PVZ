class_name Plant extends Node2D

signal planted
signal dug
signal bitten
signal eaten

@export var plant_name:String

@export var cost:int
@export var max_health:int
@export var max_cooldown:int = 5

@export var shaderPlayer: Node
@export var animationPlayer: Node

@export var hitbox: Area2D
@export var bottom:Marker2D

@export var idleAnim = 'idle'

var health:float = max_health
var activated:bool = false

var curTile:Vector2

func dance(_anim = idleAnim):
	if _anim != null && animationPlayer != null:
		animationPlayer.play(_anim)

func activate():
	health = max_health
	z_index = 0
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
	global.mainScene.tilemap.dic[str(curTile)] = "Free"

func fake_remove_plant():
	visible = false
	activated = false

func reset_shaders():
	if shaderPlayer != null:
		shaderPlayer.play("RESET")

func apply_dark():
	if shaderPlayer != null:
		shaderPlayer.play("darken")

func apply_blink():
	if shaderPlayer != null:
		shaderPlayer.play("blink")
