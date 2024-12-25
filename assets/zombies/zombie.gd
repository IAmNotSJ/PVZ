class_name Zombie extends Node2D 

signal hurt

@onready var animationPlayer:AnimationPlayer = get_node("Limbs").animationPlayer

@export var max_health:float = 10
@export var eating_interval:float = 1
@export var speed:int = 7
enum {
	WALKING,
	EATING
}

enum Hat {
	BALD,
	CONE
}


var speed_modifier:float = 0
var dynamic_speed

var state = WALKING
var plant_to_eat
var health:float = max_health

var eatTimer:float = eating_interval

var effects:Dictionary = {
	"SNOW": false
}

func _physics_process(delta):
	speed_modifier = lerpf(speed_modifier, 0, 0.015)
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

func take_damage(amount:float):
	health -= amount
	hurt.emit()
	
	$ShaderPlayer.play("blink")

func add_effect(effect):
	if effect != "NORMAL":
		if effects[effect] != true:
			effects[effect] = true
			match effect:
				"SNOW":
					material.set("shader_parameter/blue", true)
					speed -= 2

func add_hat(hat:Hat):
	var dahat:ZombieHat
	match hat:
		Hat.CONE:
			dahat = load("res://assets/objects/zombie_hats/cone.tscn").instantiate()
	hurt.connect(dahat.parent_hurt.bind(self))
	$Limbs/Head/Hats.add_child(dahat)
	health += dahat.hatHealth

func _on_hitbox_area_entered(area):
	plant_to_eat = area.owner
	animationPlayer.play("eat")
	state = EATING

func _on_hitbox_area_exited(_area):
	animationPlayer.play("walk")
	state = WALKING
