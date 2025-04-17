extends ToolbarOption

const BASE_SPRITE = "res://assets/sprites/sprite.tscn"

@onready var load_sprite_dialogue = $LoadSpriteDialog

func on_new_sprite_selected():
	_on_load_sprite_dialog_file_selected(BASE_SPRITE)

func _on_load_sprite_dialog_file_selected(path: String) -> void:
	var instanced_sprite = load(path).instantiate()
	if instanced_sprite is Sprite:
		if sprite != null:
			for child in sprite.get_children():
				for layer in layer_container.get_children():
					layer.delete_self()
				await get_tree().process_frame
			sprite.queue_free()
			sprite = null
		animation_tester.sprite = instanced_sprite
		sprite_container.add_child(instanced_sprite)
		layer_container.reference = sprite
		for sprite2d in instanced_sprite.get_node("Limbs").get_children():
			add_sprite_param(sprite2d)
		await get_tree().process_frame
		layer_container.set_specific_layer_magnitude(layer_container, layer_container.magnitude)
	else:
		printerr("Selected File is not a Sprite!")

func on_load_sprite_pressed() -> void:
	if load_sprite_dialogue.visible == true:
		load_sprite_dialogue.visible = false
	else:
		load_sprite_dialogue.visible = true
