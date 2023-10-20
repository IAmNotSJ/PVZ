extends Sprite2D

@onready var mainScene = get_tree().current_scene

var rng = RandomNumberGenerator.new()

var speed:float = rng.randf_range(50, 80)

var final_placement:Vector2
var despawn_timer:float = 25
var from_sky:bool = true
var collected:bool = false

var flower_timer:float = 3

var acceleration:int = -5



func _ready():
	if from_sky:
		final_placement = Vector2(global_position.x, rng.randi_range(4,4) * 80 + 180)
	else:
		speed *= -1
		acceleration = 130
		final_placement = Vector2(global_position.x, global_position.y + 40)

func _physics_process(delta):
	if from_sky:
		if (speed > 0):
			speed = lerpf(speed,speed + acceleration, delta)
		else:
			speed = 0
	else:
		speed = lerpf(speed,speed + acceleration, delta)
	
	if (flower_timer >= 0):
		flower_timer -= delta
	global_position = global_position.move_toward(final_placement, delta * speed)
	despawn_timer -= delta
	
	if (despawn_timer < 8):
		modulate.a -= delta / 8
		if despawn_timer <= 0:
			queue_free()
	

func _on_area_2d_area_entered(_area):
	mainScene.collect_sun(25)
	final_placement = Vector2(40,40)
	speed = 10 * global_position.x
	acceleration = 0
	despawn_timer = .15
