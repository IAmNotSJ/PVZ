extends Sprite2D
class_name Pea

enum TYPE {
	NORMAL,
	SNOW,
	FIRE
}
var curType = TYPE.NORMAL
var typeString = str(TYPE.keys()[curType])

@export var speed:int = 550
@export var damage:int = 1

func _physics_process(delta):
	global_position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_area_entered(area):
	area.owner.take_damage(damage, Enums.DAMAGE_PROJECTILE)
	area.owner.add_effect(typeString)
	print(typeString)
	queue_free()

func change_type(type:TYPE):
	if curType != type:
		match type:
			TYPE.NORMAL:
				texture = load("res://assets/objects/peas/normal/pea_norm.png")
			TYPE.SNOW:
				texture = load("res://assets/objects/peas/normal/pea_snow.png")
		curType = type
		typeString = str(TYPE.keys()[curType])
