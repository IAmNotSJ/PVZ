class_name Layer extends Control

var reference:Node2D :
	set(value):
		reference = value
		if ui != null && "texture" in reference:
			ui.get_node("NameContainer/Texture").texture = reference.texture

var magnitude:int = 0

var ui:LayerUI

signal up_pressed(layer)
signal down_pressed(layer)


func _on_up_pressed() -> void:
	up_pressed.emit(self)
func _on_down_pressed() -> void:
	down_pressed.emit(self)

func reparent_self(new_parent, index:int = -1):
	reparent(new_parent)
	if reference != null && new_parent.reference != null:
		reference.reparent(new_parent.reference)
	
	if index != -1:
		new_parent.move_child(self, index)
		new_parent.reference.move_child(reference, index)
	new_parent.redo_layer_order()

func redo_layer_order():
	await get_tree().process_frame
	if ui != null:
		move_child(ui, get_children().size() - 1)
	var child_layers = get_child_layers()
	for i in child_layers.size():
		if i == 0:
			if ui != null:
				child_layers[i].position.y = ui.base_button.size.y
			else:
				child_layers[i].position.y = 0
		else:
			child_layers[i].position.y = child_layers[i - 1].position.y + (37 * get_all_layers(child_layers[i-1]).size()) + 37
		child_layers[i].change_size(child_layers[i].magnitude)

func delete_self():
	var reference_layers = get_child_layers()
	for i in range(reference_layers.size()):
		reference_layers[i].reparent_self(get_parent(), get_parent().find(self) + i)
	get_parent().redo_layer_order()
	reference.queue_free()
	queue_free()

func change_size(m):
	size.x = 145 - m * 10
	global_position.x = get_parent().global_position.x + 10
	ui.name_label.size.x = size.x - 35
	
	for control in ui.inherited_size_nodes:
		control.size = size
	for child in get_child_layers():
		child.change_size(child.magnitude)

func get_child_layers() -> Array:
	var children:Array = get_children()
	if ui != null:
		children.erase(ui)
	return children

func get_all_layers(start):
	var layer_array = []
	layer_array = return_layers(start)
	return layer_array

func get_layers_from_index(start):
	var layer_array = []
	for i in range(start.get_parent().get_child_layers().find(start), start.get_parent().get_child_layers().size()):
		layer_array += return_layers(start.get_parent().get_child_layers()[i])
	return layer_array

func return_layers(layer):
	var result = []
	for l in layer.get_children():
		if l is Layer:
			result.append(self)
			result += return_layers(l)
	return result
