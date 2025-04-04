class_name DraggableAddon extends Button

@onready var animation_tester = find_parent("Animation Tester")
@onready var parent = get_parent()
@onready var history = animation_tester.history

@onready var transform_box = $transform

var held = false
var held_offset:Vector2 = Vector2.ZERO

const SCALE_RATE = 100
var scaling:bool = false
var scale_direction:Vector2 = Vector2i(1, 1)
var original_scale:Vector2 = Vector2.ZERO
var original_scale_position:Vector2 = Vector2.ZERO 

var rotating:bool = false
var original_rotation:float = 0
var original_rotation_position:Vector2 = Vector2.ZERO


func set_button(image_size:Vector2):
	size = image_size
	$transform.size = image_size
	position -= image_size / 2

func _input(event):
	if event is InputEventMouseMotion:
		if held:
			parent.global_position = get_global_mouse_position() + held_offset
			parent.global_position.x = parent.global_position.x - (fmod(parent.global_position.x, animation_tester.movement_snap))
			parent.global_position.y = parent.global_position.y - (fmod(parent.global_position.y, animation_tester.movement_snap))
			animation_tester.update_selection(parent)
		if scaling:
			#parent.scale.x = original_scale.x + ((get_global_mouse_position().x - original_scale_position.x) * scale_direction.x / parent.texture.get_width() * 2) 
			parent.scale.y = original_scale.y + ((get_global_mouse_position().y - original_scale_position.y) * scale_direction.y / parent.texture.get_height() * 2) 
			parent.scale.x = parent.scale.y
			
			animation_tester.update_selection(parent)
		if rotating:
			#global.mouse.change_state(2, rad_to_deg(Vector2(1152/2, 648/2).angle_to_point(get_global_mouse_position())) - 45)
			#print(parent.global_position.angle_to_point(get_global_mouse_position()))
			parent.rotation_degrees = original_rotation + rad_to_deg(parent.global_position.angle_to_point(get_global_mouse_position()) - parent.global_position.angle_to_point(original_rotation_position))
			global.mouse.change_rotation_degrees(original_rotation + rad_to_deg(parent.global_position.angle_to_point(get_global_mouse_position()) - parent.global_position.angle_to_point(original_rotation_position)))
			animation_tester.update_selection(parent)
			print(parent.rotation_degrees)
	if animation_tester.focused_sprite == parent:
		var used_snap = animation_tester.movement_snap
		if Input.is_key_pressed(KEY_SHIFT):
			used_snap *= 10
		if event.is_action_pressed("up"):
			parent.global_position.y -= used_snap
			animation_tester.update_selection(parent)
			history.add_action(history.POSITION, [parent, parent.position])
		elif event.is_action_pressed("down"):
			parent.global_position.y += used_snap
			animation_tester.update_selection(parent)
			history.add_action(history.POSITION, [parent, parent.position])
		elif event.is_action_pressed("left"):
			parent.global_position.x -= used_snap
			animation_tester.update_selection(parent)
			history.add_action(history.POSITION, [parent, parent.position])
		elif event.is_action_pressed("right"):
			parent.global_position.x += used_snap
			animation_tester.update_selection(parent)
			history.add_action(history.POSITION, [parent, parent.position])

func _on_button_down() -> void:
	animation_tester.cur_held = parent
	held = true
	held_offset = parent.global_position - get_global_mouse_position()
func _on_button_up() -> void:
	animation_tester.cur_held = null
	held = false
	print('button up!')
	history.add_action(history.POSITION, [parent, parent.position])
	held_offset = Vector2.ZERO
	

func _on_mouse_entered() -> void:
	animation_tester.cur_hover.append(parent)
	global.mouse.change_state(1)
func _on_mouse_exited() -> void:
	animation_tester.cur_hover.erase(parent)
	global.mouse.change_state()



func _on_focus_entered() -> void:
	transform_box.visible = true
func _on_focus_exited() -> void:
	transform_box.visible = false
