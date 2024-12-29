extends Camera2D

signal done_moving
enum {
	START,
	DIALOGUE,
	MOVE_CAMERA,
	SELECT,
	MOVE_BACK,
	GAME
}
var state = START

@onready var HUD = $HUD

@onready var cam_position:Vector2 = Vector2(position)

func shake_screen(delta, strength, decay):
	strength = lerp(strength, 0, decay * delta)
	
	offset = get_random_offset(strength)

func get_random_offset(shake_strength) -> Vector2:
	return Vector2(
		Global.rng.randf_range(-shake_strength, shake_strength),
		Global.rng.randf_range(-shake_strength, shake_strength),
	)
