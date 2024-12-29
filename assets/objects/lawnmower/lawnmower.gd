extends Sprite2D

const speed = 300
const damage = 300

var shmoov = false

func _on_hurtbox_area_entered(_area):
	shmoov = true

func _physics_process(delta):
	if shmoov == true:
		global_position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hitbox_area_entered(area):
	area.owner.take_damage(damage, Enums.DAMAGE_PHYSICAL)
