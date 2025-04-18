extends Node2D

signal selection_changed(new_selection)
signal selection_cleared()

@onready var load_sprite_dialogue = %LoadSpriteDialog
@onready var add_image_dialogue = %AddImageDialog
@onready var sprite_container = %SpriteContainer
@onready var layer_container = %LayerContainer
@onready var inspector = %Inspector
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
			final_zoom = clamp(final_zoom, 1, 4)
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

func _on_gui_focus_changed(control):
	var new_selection = true
	if focused_sprite != control:
		if control is DraggableAddon:
			focused_sprite = control.parent
		elif control is LineEdit:
			return
		else:
			focused_sprite = null
	else:
		new_selection = false
	if focused_sprite != null:
		update_selection(focused_sprite)
		if new_selection:
			selection_changed.emit(control)
	else:
		overview.visible = false

func update_selection(reference:Sprite2D):
	overview.visible = true
	var texture = reference.texture
	var path_array = texture.resource_path.split("/")
	overview.get_node("Preview").texture = reference.texture
	overview.get_node("Name").text = path_array[path_array.size() - 1]
	overview.get_node("Descriptions").text = "Position: " + str(reference.position) + "\nRotation: " + str(reference.rotation_degrees) + "°\nScale: " + str(reference.scale)
	
	inspector.update_values()

func deselect() -> void:
	get_viewport().gui_release_focus()
	focused_sprite = null
	overview.visible = false
	selection_cleared.emit()
