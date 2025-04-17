class_name LayerContainer extends Layer

signal layer_added


const LAYER_SCENE = preload("res://debug/animation_tester/layers/layer.tscn")
const UI_SCENE = preload("res://debug/animation_tester/layers/ui/ui.tscn")
var sprite:Sprite :
	get():
		return find_parent("Animation Tester").sprite

func create_layer(ref, parent = self):
	var instanced_layer = LAYER_SCENE.instantiate()
	var path_array = ref.texture.resource_path.split("/")
	
	var instanced_UI = UI_SCENE.instantiate()
	instanced_UI.layer_name = path_array[path_array.size() - 1]
	instanced_layer.name = path_array[path_array.size() - 1]
	
	instanced_layer.ui = instanced_UI
	instanced_layer.reference = ref
	instanced_layer.magnitude = parent.magnitude + 1
	
	parent.add_child(instanced_layer)
	instanced_layer.add_child(instanced_UI)
	redo_layer_order()
	
	instanced_layer.ui.up_button.pressed.connect(_on_layer_up_pressed.bind(instanced_layer))
	instanced_layer.ui.down_button.pressed.connect(_on_layer_down_pressed.bind(instanced_layer))
	instanced_layer.ui.trash_button.pressed.connect(_on_layer_trash_pressed.bind(instanced_layer))
	instanced_layer.ui.base_button.pressed.connect(_on_layer_base_pressed.bind(instanced_layer))
	
	layer_added.emit()

func move_layer(layer, amt:int):
	var layer_parent = layer.get_parent()
	var layer_index = layer_parent.get_children().find(layer)
	
	var sprite_parent
	var sprite_index
	if layer.reference != null:
		sprite_parent = layer.reference.get_parent()
		sprite_index = sprite_parent.get_children().find(layer.reference)
	
	if !Input.is_key_pressed(KEY_CTRL):
		if amt < 0:
			#Going Up
			if layer_index <= 0:
				return
		elif amt > 0:
			#Going Down
			if layer_index >= layer_parent.get_child_layers().size() - 1:
				return
		
	if Input.is_key_pressed(KEY_SHIFT):
		var destination = layer_parent.get_child_layers()[layer_index + amt]
		if amt > 0:
			#Down
			layer.reparent_self(destination, 0)
		else:
			#Up
			layer.reparent_self(destination, destination.get_child_layers().size())
		set_specific_layer_magnitude(self, 0)
		
		layer_parent.redo_layer_order()
		destination.redo_layer_order()
	elif Input.is_key_pressed(KEY_CTRL):
		if layer.magnitude > 0:
			var destination = layer_parent.get_parent()
			if amt > 0:
				#Down
				layer.reparent_self(destination, destination.get_children().find(layer_parent) + 1)
			else:
				#Up
				layer.reparent_self(destination, destination.get_children().find(layer_parent))
			set_specific_layer_magnitude(self, 0)
			
			layer_parent.redo_layer_order()
			destination.redo_layer_order()
	else:
		layer_parent.move_child(layer, layer_index + amt)
		if sprite_parent != null:
			sprite_parent.move_child(layer.reference, sprite_index + amt)
		layer_parent.redo_layer_order()

func _on_layer_up_pressed(layer):
	move_layer(layer, -1)
func _on_layer_down_pressed(layer):
	move_layer(layer, 1)
func _on_layer_trash_pressed(layer):
	layer.delete_self()
func _on_layer_base_pressed(layer):
	layer.reference.get_children()[layer.reference.get_children().size() - 1].grab_focus()

func redo_layer_order():
	super()
	custom_minimum_size.y = get_all_layers(self).size() * 37

func set_specific_layer_magnitude(layer, m):
	for l in layer.get_children():
		if l is Layer:
			l.magnitude = m
			set_specific_layer_magnitude(l, m + 1)
