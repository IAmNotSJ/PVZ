extends Control

@onready var reference

@onready var children  = %children
@onready var container = %container
@onready var button = %button

@export var category_name:String :
	set(value):
		category_name = value
		%button.text = category_name

const variable_class = preload("res://debug/animation_tester/inspector/variable/variable.tscn")
const variable_types:Dictionary = {
	"bool" : preload("res://debug/animation_tester/inspector/variable/types/bool/bool.tscn"),
	"int" : preload("res://debug/animation_tester/inspector/variable/types/int/int.tscn"),
	"String" : preload("res://debug/animation_tester/inspector/variable/types/string/string.tscn"),
	"Vector2" : preload("res://debug/animation_tester/inspector/variable/types/vector2/vector2.tscn")
}

func load_variables(list:Array):
	for variable in list:
		if variable in reference:
			
			var instanced_variable = variable_class.instantiate()
			children.add_child(instanced_variable)
			instanced_variable.variable_name = variable
			instanced_variable.reference = reference
			
			var setter
			# no better way to do this i think
			if reference.get(variable) is bool:
				setter = return_instanced_variable_type("bool")
				setter.button_pressed = reference.get(variable)
			elif reference.get(variable) is int:
				setter = return_instanced_variable_type("int")
				setter.value = reference.get(variable)
			elif reference.get(variable) is float:
				setter = return_instanced_variable_type("int")
				setter.value = reference.get(variable)
			elif reference.get(variable) is String:
				setter = return_instanced_variable_type("String")
				setter.text = reference.get(variable)
			elif reference.get(variable) is Vector2:
				setter = return_instanced_variable_type("Vector2")
				setter.value = reference.get(variable)
			
			if setter != null:
				instanced_variable.set_setter(setter)
	_on_button_toggled(button.button_pressed)

func return_instanced_variable_type(type:String):
	var instanced_type = variable_types[type].instantiate()
	return instanced_type

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		children.visible = true
		custom_minimum_size.y = children.size.y + button.size.y
	else:
		children.visible = false
		custom_minimum_size.y = button.size.y


func _on_children_child_order_changed() -> void:
	var min_size:int = 0
	for child in children.get_children():
		min_size += child.size.y
	children.custom_minimum_size.y = min_size
