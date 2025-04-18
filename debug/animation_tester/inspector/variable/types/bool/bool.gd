extends CheckBox

signal new_value(value)

@onready var value :
	set(val):
		button_pressed = val
	get():
		return button_pressed

func _on_pressed() -> void:
	new_value.emit(button_pressed)
