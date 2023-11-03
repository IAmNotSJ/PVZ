class_name Zombie extends Node2D 

@onready var mainScene = get_tree().current_scene

const speed:int = 7
const max_health:float = 5
const eating_interval:float = 1

enum {
	WALKING,
	EATING
}

var speed_modifier:float = 0
var dynamic_speed

var stage:int = 0

var state = WALKING
var plant_to_eat
var health:float = max_health

var eatTimer:float = eating_interval

func _physics_process(delta):
	speed_modifier = lerpf(speed_modifier, 0, 0.005)
	dynamic_speed = speed * speed_modifier * delta * 60
	
	match state:
		WALKING:
			walk_state(delta)
		EATING:
			eat_state(delta)

func walk_state(delta):
	global_position.x -= dynamic_speed * delta

func step():
	speed_modifier = 5;

func eat_state(delta):
	if (plant_to_eat != null && plant_to_eat.activated == true):
		eatTimer -= delta
		if (eatTimer <= 0):
			eatTimer = eating_interval
			plant_to_eat.take_damage(1)

func _on_area_2d_area_entered(area):
	take_damage(area.owner.damage)

func take_damage(amount:float):
	health -= amount
	
	$ShaderPlayer.play("blink")
	
	if health <= 0:
		queue_free()
	elif health <= 2:
		change_stage(1)

func change_stage(da_stage:int):
	
	match da_stage:
		1:
			if (stage < 1):
				stage = 1
				print('stage 1 changed!!!!!')
				$"Limbs/Arm 1/Bottom Sleeve".queue_free()
				$"Limbs/Arm 1/Hand".queue_free()

func _on_hitbox_area_entered(area):
	plant_to_eat = area.owner
	state = EATING

func _on_hitbox_area_exited(_area):
	state = WALKING
