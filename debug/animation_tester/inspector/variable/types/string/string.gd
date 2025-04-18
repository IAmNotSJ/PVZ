extends LineEdit

@onready var value : 
	set(val):
		text = val
	get():
		return text

signal new_value(value)

func _on_text_changed(new_text: String) -> void:
	new_value.emit(new_text)
