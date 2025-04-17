extends CheckBox

signal new_value(value)



func _on_pressed() -> void:
	new_value.emit(button_pressed)
