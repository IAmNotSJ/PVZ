extends Control

const LAYER_SCENE = preload("res://debug/animation_tester/layers/layer.tscn")
var sprite:Sprite :
	get():
		return find_parent("Animation Tester").sprite

func create_layer(reference):
	var instanced_layer = LAYER_SCENE.instantiate()
	var path_array = reference.texture.resource_path.split("/")
	instanced_layer.layer_name = path_array[path_array.size() - 1]
	instanced_layer.sprite2d = reference
	add_child(instanced_layer)
	_redo_layer_order()
	
	instanced_layer.up_pressed.connect(_on_layer_up_pressed)
	instanced_layer.down_pressed.connect(_on_layer_down_pressed)

func _on_layer_up_pressed(layer):
	if Input.is_action_pressed("shift"):
		print('trying to reparent self')
		var layer_index = get_children().find(layer)
		if layer_index > 0:
			var layer_above = get_children()[layer_index - 1]
			layer.sprite2d.reparent(layer_above.sprite2d)
			layer.reparent_self(layer_above)
			
			_redo_layer_order()
	else:
		var layer_index = layer.sprite2d.get_parent().get_children().find(self)
		var real_index = layer_index + 1
		layer.sprite2d.get_parent().move_child(layer.sprite2d, real_index)
		_redo_layer_order()
func _on_layer_down_pressed(layer):
	if Input.is_action_pressed("shift"):
		var layer_index = get_children().find(layer)
		if layer_index < get_children().size() - 1:
			var layer_below = get_children()[layer_index + 1]
			layer.sprite2d.reparent(layer_below.sprite2d)
			layer.reparent_self(layer_below)
			
			_redo_layer_order()
	else:
		var layer_index = layer.sprite2d.get_parent().get_children().find(self)
		if layer_index > 0:
			var real_index = layer_index - 1
			layer.sprite2d.get_parent().move_child(layer.sprite2d, real_index)
			_redo_layer_order()
func _redo_layer_order():
	for layer in get_children():
		move_child(layer, get_children().size() - 1 - sprite.get_node("Limbs").get_children().find(layer.sprite2d))
	for i in get_children().size():
		if i == 0:
			get_children()[i].position.y = 0
		else:
			get_children()[i].position.y = get_children()[i - 1].position.y + (37 * get_children()[i-1].children.size()) + 37


func _on_child_order_changed() -> void:
	if get_tree() != null:
		await get_tree().process_frame
		var layer_count:int = 0
		for i in range(get_children().size()):
			layer_count += 1
			for j in range(get_children()[i].children.size()):
				layer_count += 1
		custom_minimum_size.y = layer_count * 37

func get_child_counts():
	pass
