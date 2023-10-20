extends Node2D

@onready var mainScene = get_tree().current_scene
@onready var parent = $Plant

var sunScene = load("res://assets/objects/sun/sun.tscn")

@export var maxProductionTimer:int = 7
var productionTimer:float = maxProductionTimer

var curTile:Vector2

var rng = RandomNumberGenerator.new()

func _process(delta):
	parent._process(delta)
	if parent.activated:
		productionTimer -= delta
		if productionTimer <= 0:
			productionTimer = rng.randf_range(maxProductionTimer - 2, maxProductionTimer + 2)
			$AnimationPlayer.play("sun")

func dance():
	parent.dance()
	$AnimationPlayer.play("idle")

func produce_sun():
	print('sun produced!')
	var sun = sunScene.instantiate()
	sun.global_position = $sun_anchor.position
	sun.from_sky = false
	add_child(sun)

#PARENT FUNCTIONS!!!!!!!!
func activate():
	parent.activate()

func take_damage(amount:float):
	parent.take_damage()

func remove_plant():
	parent.remove_plant()

func apply_dark():
	parent.apply_dark()

func reset_shaders():
	parent.reset_shaders()
