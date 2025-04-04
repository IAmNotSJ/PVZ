extends TextureRect

@onready var addon = find_parent("DraggableAddon")
var parent
var history

var delay_rotation_change:bool = false
func _ready():
	var scale_buttons = [$scale_detection_1, $scale_detection_2, $scale_detection_3, $scale_detection_4]
	var rotate_buttons = [$rotate_detection_1, $rotate_detection_2, $rotate_detection_3, $rotate_detection_4]
	
	for button in scale_buttons:
		button.button_down.connect(_on_scale_detection_button_down)
		button.button_up.connect(_on_scale_detection_button_up)
		button.mouse_entered.connect(_on_scale_detection_mouse_entered.bind(button))
		button.mouse_exited.connect(_on_scale_detection_mouse_exited)
	for button in rotate_buttons:
		button.mouse_entered.connect(_on_rotate_detection_mouse_entered)
		button.mouse_exited.connect(_on_rotate_detection_mouse_exited)
		button.button_down.connect(_on_rotate_detection_button_down)
		button.button_up.connect(_on_rotate_detection_button_up)
	
	await get_tree().process_frame
	history = addon.animation_tester.history
	parent = get_parent().parent

func _on_scale_detection_mouse_entered(button) -> void:
	if button.position.x > 0:
		addon.scale_direction.x = 1
	else:
		addon.scale_direction.x = -1
	if button.position.y > 0:
		addon.scale_direction.y = 1
	else:
		addon.scale_direction.y = -1
	
	print(rad_to_deg(Vector2.ZERO.angle_to_point(addon.scale_direction)))
	global.mouse.change_state(3)
func _on_scale_detection_mouse_exited() -> void:
	global.mouse.change_state()
func _on_scale_detection_button_down() -> void:
	addon.scaling = true
	addon.original_scale_position = get_global_mouse_position()
	addon.original_scale = addon.parent.scale
	addon.animation_tester.cur_held = addon.parent
func _on_scale_detection_button_up() -> void:
	addon.scaling = false
	addon.original_scale_position = Vector2.ZERO
	addon.original_scale = Vector2.ZERO
	addon.animation_tester.cur_held = null
	history.add_action(history.SCALE, [parent, parent.scale])

func _on_rotate_detection_mouse_entered() -> void:
	global.mouse.change_state(2, rad_to_deg(Vector2(1152.0/2.0, 648.0/2.0).angle_to_point(get_global_mouse_position())))
	delay_rotation_change = false
func _on_rotate_detection_mouse_exited() -> void:
	if addon.rotating:
		delay_rotation_change = true
	else:
		global.mouse.change_state()
func _on_rotate_detection_button_down():
	addon.rotating = true
	addon.original_rotation_position = get_global_mouse_position()
	addon.original_rotation = addon.parent.rotation_degrees
	addon.animation_tester.cur_held = addon.parent
func _on_rotate_detection_button_up():
	addon.rotating = false
	if delay_rotation_change:
		global.mouse.change_state()
	addon.animation_tester.cur_held = null
	history.add_action(history.ROTATION, [parent, parent.rotation_degrees])
