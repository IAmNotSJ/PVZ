extends Node2D

@onready var mainScene = get_tree().current_scene

enum {
	IDLE,
	NOTICE,
	ATTACK
}

var state = IDLE

var sunScene = load("res://assets/objects/sun/sun.tscn")

var rng = RandomNumberGenerator.new()

const cost:int = 125
const max_health = 1

var stored_sun:float = 0

var health = max_health
var activated:bool = false

var attack_speed = .1

var notice_timer = 1.5

var curTile:Vector2

func _physics_process(delta):
	attack_speed -= delta
	match state:
		IDLE:
			idle_state(delta)
		NOTICE:
			notice_state(delta)
		ATTACK:
			attack_state()

func idle_state(_delta):
	if $hitbox.has_overlapping_areas() and activated:
		state = NOTICE

func notice_state(delta):
	notice_timer -= delta
	
	if (notice_timer <= 0):
		state = ATTACK
		notice_timer = 1.5

func attack_state():
	if !$hitbox.has_overlapping_areas():
		state = IDLE
		print(int(round(stored_sun)))
		produce_sun(int(round(stored_sun)))
	else:
		if (attack_speed <= 0):
			$hitbox.get_overlapping_areas()[0].owner.take_damage(.1)
			attack_speed = .1
			stored_sun += .48

func dance():
	$AnimationPlayer.play("idle")

func produce_sun(value):
	print('sun produced!')
	var sun = sunScene.instantiate()
	sun.global_position = $sun_anchor.position
	sun.value = value
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
