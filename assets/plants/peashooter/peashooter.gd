extends Node2D

@onready var mainScene = get_tree().current_scene

const cost:int = 100
const maxShootingTimer:int = 2
const max_health = 1

var health = max_health
var shootingTimer:float = maxShootingTimer
var activated:bool = false
var can_shoot:bool = false

var curTile:Vector2

var peaScene = load('res://assets/plants/peashooter/pea.tscn')

func shoot():
	var pea = peaScene.instantiate()
	mainScene.add_child(pea)
	pea.global_position = $Marker2D.global_position
func _process(delta):
	can_shoot = false
	if ($hitbox.has_overlapping_areas()):
		can_shoot = true
	if activated:
		shootingTimer -= delta
		if can_shoot:
			if shootingTimer <= 0:
				shootingTimer = maxShootingTimer
				$ShootingPlayer.play("shoot")

func dance():
	$AnimationPlayer.play("idle")

func activate():
	$hurtbox.collision_layer = 2
	dance()
	activated = true

func take_damage(amount:float):
	health -= amount
	$"Blink player".play("blink")
	
	if health <= 0:
		remove_plant()

func remove_plant():
	queue_free()
	mainScene.tilemap.dic[str(curTile)] = "Free"

func apply_dark():
	$"ShaderPlayer".play("darken")
func reset_shaders():
	$"ShaderPlayer".play("RESET")
