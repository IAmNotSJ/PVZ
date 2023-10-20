extends Node2D

@onready var mainScene = get_tree().current_scene

@export var cost:int
@export var max_health:int

var health = max_health
var activated:bool = false

var curTile:Vector2

var rng = RandomNumberGenerator.new()

func _process(delta):
	if activated:
		pass

func dance():
	pass

func activate():
	activated = true
	$hurtbox.collision_layer = 2
	dance()

func take_damage(amount:float):
	health -= amount
	$"Shader Player".play("blink")
	
	if health <= 0:
		remove_plant()

func remove_plant():
	queue_free()
	mainScene.tilemap.dic[str(curTile)] = {"Availability": "Free"}

func reset_shaders():
	$"ShaderPlayer".play("RESET")

func apply_dark():
	$"ShaderPlayer".play("darken")
