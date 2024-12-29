class_name Zombie extends Node2D 

signal hurt(damage)

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

var damage_cooldown:Timer = Timer.new()

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

func take_damage(amount:float, _type:int):
	health -= amount
	hurt.emit(amount)
	
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
	var hat_container = $Limbs/Head/Hats
	var dahat:ZombieHat
	match hat:
		Hat.CONE:
			dahat = load("res://assets/objects/zombie_hats/cone.tscn").instantiate()
	hurt.connect(dahat.parent_hurt.bind(self))
	dahat.position.y = hat_container.get_children().size() * -10
	hat_container.add_child(dahat)
	dahat.is_primary = true
	for i in range(hat_container.get_children().size()):
		if hat_container.get_children()[i] != dahat:
			hat_container.get_children()[i].is_primary = false
	health += dahat.max_health

func _on_hitbox_area_entered(area):
	plant_to_eat = area.owner
	animationPlayer.play("eat")
	state = EATING

func _on_hitbox_area_exited(_area):
	animationPlayer.play("walk")
	state = WALKING
