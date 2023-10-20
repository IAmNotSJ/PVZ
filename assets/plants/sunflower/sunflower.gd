extends Node2D

@onready var mainScene = get_tree().current_scene

var sunScene = load("res://assets/objects/sun/sun.tscn")

var rng = RandomNumberGenerator.new()

const cost:int = 50
const maxProductionTimer:int = 24
const max_health = 1

var health = max_health
var productionTimer:float = rng.randi_range(4,8)
var activated:bool = false

var curTile:Vector2



func _process(delta):
	if activated:
		productionTimer -= delta
		if productionTimer <= 0:
			productionTimer = maxProductionTimer
			$AnimationPlayer.play("sun")

func dance():
	$AnimationPlayer.play("idle")

func produce_sun():
	print('sun produced!')
	var sun = sunScene.instantiate()
	sun.global_position = $sun_anchor.position
	sun.from_sky = false
	add_child(sun)
	
func activate():
	$hurtbox.collision_layer = 2
	dance()
	activated = true

func take_damage(amount:float):
	health -= amount
	$"Shader Player".play("blink")
	
	if health <= 0:
		remove_plant()

func remove_plant():
	queue_free()
	mainScene.tilemap.dic[str(curTile)] = "Free"

func apply_dark():
	$"ShaderPlayer".play("darken")
	
func reset_shaders():
	$"ShaderPlayer".play("RESET")
