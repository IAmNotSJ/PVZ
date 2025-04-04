extends VBoxContainer

const LAYER_SCENE = preload("res://debug/animation_tester/layers/layer.tscn")
var sprite:Sprite :
	get():
		return find_parent("Animation Tester").sprite

func create_layer(sprite2d:Sprite2D):
	var instanced_layer = LAYER_SCENE.instantiate()
	var path_array = sprite2d.texture.resource_path.split("/")
	instanced_layer.layer_name = path_array[path_array.size() - 1]
	instanced_layer.sprite2d = sprite2d
	add_child(instanced_layer)
	_redo_layer_order()
	
	instanced_layer.up_pressed.connect(_on_layer_up_pressed)
	instanced_layer.down_pressed.connect(_on_layer_down_pressed)

func _on_layer_up_pressed(layer):
	var layer_index = sprite.get_node("Limbs").get_children().find(layer.sprite2d)
	var real_index = layer_index + 1
	sprite.get_node("Limbs").move_child(layer.sprite2d, real_index)
	_redo_layer_order()
func _on_layer_down_pressed(layer):
	var layer_index = sprite.get_node("Limbs").get_children().find(layer.sprite2d)
	if layer_index > 0:
		var real_index = layer_index - 1
		sprite.get_node("Limbs").move_child(layer.sprite2d, real_index)
		_redo_layer_order()
func _redo_layer_order():
	for layer in get_children():
		move_child(layer, get_children().size() - 1 - sprite.get_node("Limbs").get_children().find(layer.sprite2d))
