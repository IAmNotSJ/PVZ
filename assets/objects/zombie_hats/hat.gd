class_name ZombieHat extends Sprite2D

const fall_prop = preload("res://assets/objects/zombie_hats/falling/falling_cone.tscn")

var is_primary

@export var max_health:float = 10
var hat_health = max_health

@export var stages:Array = [
	Vector2(5, 10),
	Vector2(2, 5),
	Vector2(0, 2)
]

func parent_hurt(amount:float, _parent):
	print('is primary: ' + str(is_primary))
	if is_primary:
		hat_health -= amount
	if frame + 1 >= stages.size():
		if hat_health <= stages[frame].x:
			var fall = fall_prop.instantiate()
			fall.global_position = global_position
			fall.get_node('sprite/anim').play('fall')
			global.mainScene.add_child(fall)
			queue_free()
	for i in range(stages.size()):
		if Util.is_between(hat_health, stages[i]):
			frame = i
