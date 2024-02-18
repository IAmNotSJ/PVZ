extends Node

@onready var camera = get_parent()

enum {
	START,
	DIALOGUE,
	MOVE_CAMERA,
	SELECT,
	MOVE_BACK,
	GAME
}
var state = START

func _process(delta):
	match state:
		START:
			start_state()
		DIALOGUE:
			pass
		MOVE_CAMERA:
			move_camera_state(delta)
		SELECT:
			select_state()
		MOVE_BACK:
			move_back_state(delta)

func start_state():
	camera.cam_position = Vector2(1109, 321)
	
	state = MOVE_CAMERA

func move_camera_state(delta):
	if Input.is_action_just_pressed("ui_accept"):
		camera.position.x = 1109
		state = GAME
	camera.position = camera.position.move_toward(camera.cam_position, 50 * delta)
	
	if (camera.position.x == 1109):
		state = SELECT
		camera.HUD.selectionScreen.visible = true
		for i in range(camera.HUD.selectionScreen.packets.size()):
			camera.HUD.selectionScreen.packets[i].clicked.connect(camera.HUD.selectionScreen.packet_clicked.bind(camera.HUD.selectionScreen.packets[i]))

func select_state():
	if Input.is_action_just_pressed("ui_accept"):
		state = MOVE_BACK
		camera.cam_position.x = 576
		camera.HUD.selectionScreen.visible = false

func move_back_state(delta):
	if Input.is_action_just_pressed("ui_accept"):
		camera.position.x = 576
		state = GAME
	camera.position = camera.position.move_toward(camera.cam_position, 50 * delta)
	
	if (camera.position.x == 576):
		state = GAME
		camera.done_moving.emit()
		for i in range(camera.HUD.selectionScreen.packets.size()):
			camera.HUD.selectionScreen.packets[i].clicked.disconnect(camera.HUD.selectionScreen.packet_clicked.bind(camera.HUD.selectionScreen.packets[i]))
