extends Panel

@onready var full_back = %full_back
@onready var frame_back = %frame_back
@onready var play = %play
@onready var frame_forward = %frame_forward
@onready var full_forward = %full_forward
@onready var time = %time
@onready var animation_button = %animation_button
@onready var animation_list = %animation_list

var animations = []

func _ready():
	animation_button.get_popup().id.connect(animation_buton_item_pressed)


func _on_animation_list_toggled(toggled_on: bool) -> void:
	animation_list.clear()
	
	for animation in animations:
		animation_list.get_popup().add_item(animation)
	
	if toggled_on:
		global.mouse.use_system_mouse()
	else:
		global.mouse.use_custom_mouse()


func _on_animation_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		global.mouse.use_system_mouse()
	else:
		global.mouse.use_custom_mouse()

func animation_buton_item_pressed(item_id:int):
	pass
