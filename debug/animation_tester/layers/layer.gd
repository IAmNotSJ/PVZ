extends Control

var sprite2d :
	set(value):
		sprite2d = value
		%Texture.texture = sprite2d.texture
var layer_name:String :
	set(value):
		layer_name = value
		%Name.text = layer_name

var children = []

@onready var inherited_size_nodes = [$BasePanel, $NameContainer, $ButtonContainer]

signal up_pressed(layer)
signal down_pressed(layer)


func _on_up_pressed() -> void:
	up_pressed.emit(self)
func _on_down_pressed() -> void:
	down_pressed.emit(self)

func reparent_self(new_parent):
	print('is reparent self working?')
	if "children" in get_parent():
		get_parent().children.erase(self)
	reparent(new_parent)
	new_parent.children.append(self)
	new_parent.redo_layer_order()

func redo_layer_order():
	print("NEW PARENT CHILDREN:" + str(children))
	for layer in children:
		move_child(layer, children.size() - 1 - sprite2d.get_children().find(layer.sprite2d))
	for i in children.size():
		children[i].position.y = 37 * (i + children[i].children.size() + 1)
		children[i].change_size(1)

func change_size(magnitude:int):
	size.x = 145 - magnitude * 10
	position.x = magnitude * 10
	%Name.size.x = size.x - 35
	
	for control in inherited_size_nodes:
		control.size = size
