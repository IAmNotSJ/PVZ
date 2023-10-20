extends Sprite2D

@onready var mainScene = get_tree().current_scene

const cost:int = 50
const max_health = 5

var health = max_health
var activated:bool = false

var curTile:Vector2

var rng = RandomNumberGenerator.new()

func activate():
	$hurtbox.collision_layer = 2
	activated = true

func take_damage(amount:float):
	health -= amount
	
	if health <= 0:
		remove_plant()

func remove_plant():
	queue_free()
	mainScene.tilemap.dic[str(curTile)] = "Free"

func apply_dark():
	#$"ShaderPlayer".play("darken")
	pass
func reset_shaders():
	#$"ShaderPlayer".play("RESET")
	pass
