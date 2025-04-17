extends Control

@onready var reference 
var variable_name :
	set(value):
		variable_name = value
		$label.text = variable_name

var setter

func set_setter(new_setter):
	if setter != null:
		setter.queue_free()
		setter = null
	add_child(new_setter)
	redo_size()
	setter = new_setter
	new_setter.position = Vector2(size.x - new_setter.size.x - 15, 0)
	new_setter.new_value.connect(_on_setter_value_changed)

func redo_size():
	var setters = get_children()
	setters.erase($label)
	custom_minimum_size.y = 0
	for s in setters:
		custom_minimum_size.y += s.size.y
	$label.custom_minimum_size.y = custom_minimum_size.y
	$label.size.y = size.y

func _on_setter_value_changed(new_value):
	if variable_name in reference:
		reference.set(variable_name, new_value)
		print(reference)
