extends ToolbarOption

@onready var add_image_dialogue = $AddImageDialog

func on_add_image_pressed() -> void:
	if add_image_dialogue.visible == true:
		add_image_dialogue.visible = false
	else:
		add_image_dialogue.visible = true

func _on_add_image_dialog_files_selected(paths: PackedStringArray) -> void:
	if sprite != null:
		for path in paths:
			var loaded_image:CompressedTexture2D = load(path)
			var sprite2d = create_sprite(loaded_image, Vector2(0, 0), 0, Vector2(1, 1))
			add_sprite_param(sprite2d)
	else:
		printerr("Please load a sprite first!")
