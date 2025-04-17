extends Sprite2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func _input(event):
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position()
func change_state(state:int = 0, rotation_deg = 0):
	match state:
		0:
			$AnimationPlayer.play("default")
		1:
			$AnimationPlayer.play("hand")
		2:
			$AnimationPlayer.play("rotate")
		3:
			$AnimationPlayer.play("scale")
	rotation_degrees = rotation_deg
func change_rotation_degrees(rotation_deg):
	rotation_degrees = rotation_deg

func use_system_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide()
func use_custom_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show()
