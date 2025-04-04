extends Node2D

@onready var load_sprite_dialogue = %LoadSpriteDialog
@onready var add_image_dialogue = %AddImageDialog
@onready var sprite_container = %SpriteContainer
@onready var layer_container = %LayerContainer
@onready var overview = %Overview
@onready var camera = %Camera
@onready var history = $History

const LAYER_SCENE = preload("res://debug/animation_tester/layers/layer.tscn")
const DRAGGABLE_ADDON = preload("res://debug/animation_tester/draggable_addon/draggable_addon.tscn")
var sprite:Sprite

@onready var grid_position:Vector2 = $grid.global_position
var cur_held
var cur_hover = []

var focused_sprite:Sprite2D

const ZOOM_STEP:float = 0.1
const ZOOM_SPEED:float = 10
var final_zoom:float = 1.0

var movement_snap:float = 1.0

func _ready():
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("click") and cur_hover == [] and cur_held == null:
		camera.global_position -= event.relative
	if event is InputEventMouseButton:
		if cur_hover == [] and cur_held == null:
			if event.is_action_pressed("scroll_up"):
				final_zoom += ZOOM_STEP
			elif event.is_action_pressed("scroll_down"):
				final_zoom -= ZOOM_STEP
			final_zoom = clamp(final_zoom, 1, 3)
		if event.is_action_pressed("cancel"):
			if focused_sprite != null:
				focused_sprite.scale = Vector2(1, 1)
				focused_sprite.rotation = 0
				update_selection(focused_sprite)
	if event.is_action_pressed("undo"):
		print('attempting undo!')
		history.undo()

func _process(delta):
	camera.zoom = lerp(camera.zoom, Util.vector2s(final_zoom), ZOOM_SPEED * delta)

func _on_load_sprite_pressed() -> void:
	if load_sprite_dialogue.visible == true:
		load_sprite_dialogue.visible = false
	else:
		load_sprite_dialogue.visible = true

func _on_add_image_pressed() -> void:
	if add_image_dialogue.visible == true:
		add_image_dialogue.visible = false
	else:
		add_image_dialogue.visible = true

func _on_load_sprite_dialog_file_selected(path: String) -> void:
	var instanced_sprite = load(path).instantiate()
	if instanced_sprite is Sprite:
		if sprite != null:
			sprite.queue_free()
			sprite = null
		sprite = instanced_sprite
		sprite_container.add_child(instanced_sprite)
		for sprite2d in instanced_sprite.get_node("Limbs").get_children():
			_add_sprite_param(sprite2d)
	else:
		printerr("Selected File is not a Sprite!")

func _on_add_image_dialog_files_selected(paths: PackedStringArray) -> void:
	if sprite != null:
		for path in paths:
			var loaded_image:CompressedTexture2D = load(path)
			var sprite2d = _create_sprite(loaded_image, Vector2(0, 0), 0, Vector2(1, 1))
			_add_sprite_param(sprite2d)
	else:
		printerr("Please load a sprite first!")

func _create_sprite(texture, pos, rot, scal, ) -> Sprite2D:
	var sprite2d = Sprite2D.new() 
	sprite2d.texture = texture
	sprite.get_node("Limbs").add_child(sprite2d)
	
	sprite2d.position = pos
	sprite2d.rotation_degrees = rot
	sprite2d.scale = scal
	return sprite2d
func _add_sprite_param(sprite):
	history.add_action(history.POSITION, [sprite, sprite.position])
	history.add_action(history.ROTATION, [sprite, sprite.rotation_degrees])
	history.add_action(history.SCALE, [sprite, sprite.scale])
	
	layer_container.create_layer(sprite)
	
	var draggable_addon = DRAGGABLE_ADDON.instantiate()
	draggable_addon.set_button(sprite.texture.get_size())
	sprite.add_child(draggable_addon)

func _on_gui_focus_changed(control):
	if control is DraggableAddon:
		focused_sprite = control.parent
	else:
		focused_sprite = null
	
	if focused_sprite != null:
		update_selection(focused_sprite)
	else:
		overview.visible = false

func update_selection(reference:Sprite2D):
	overview.visible = true
	var texture = reference.texture
	var path_array = texture.resource_path.split("/")
	overview.get_node("Preview").texture = reference.texture
	overview.get_node("Name").text = path_array[path_array.size() - 1]
	overview.get_node("Descriptions").text = "Position: " + str(reference.position) + "\nRotation: " + str(reference.rotation_degrees) + "°\nScale: " + str(reference.scale)

func _on_deselect_pressed() -> void:
	get_viewport().gui_release_focus()


func _on_move_pressed() -> void:
	pass # Replace with function body.
func _on_rotate_pressed() -> void:
	pass # Replace with function body.
func _on_scale_pressed() -> void:
	pass # Replace with function body.
