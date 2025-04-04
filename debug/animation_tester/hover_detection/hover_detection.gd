extends Control

@onready var animation_tester = find_parent("Animation Tester")
@onready var parent = get_parent()

func _on_mouse_entered() -> void:
	animation_tester.cur_hover.append(parent)
func _on_mouse_exited() -> void:
	animation_tester.cur_hover.erase(parent)
