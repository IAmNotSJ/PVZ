extends ColorPickerButton

signal new_value(val)

@onready var value : 
	set(val):
		color = val
	get():
		return color

func _on_color_changed(daColor: Color) -> void:
	new_value.emit(daColor)



func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
			global.mouse.use_system_mouse()
	else:
		global.mouse.use_custom_mouse()
