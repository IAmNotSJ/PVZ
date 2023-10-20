extends Sprite2D

const speed:int = 550
const damage:int = 1

func _physics_process(delta):
	global_position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_area_entered(_area):
	queue_free()
