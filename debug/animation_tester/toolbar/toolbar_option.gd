class_name ToolbarOption extends MenuButton

@onready var animation_tester = find_parent("Animation Tester")

@onready var sprite :
	get():
		return animation_tester.sprite
@onready var layer_container
@onready var sprite_container
@onready var history

const DRAGGABLE_ADDON = preload("res://debug/animation_tester/draggable_addon/draggable_addon.tscn")

func _ready():
	await get_tree().process_frame
	layer_container = animation_tester.layer_container
	sprite_container = animation_tester.sprite_container
	history = animation_tester.history

func create_sprite(texture, pos, rot, scal, ) -> Sprite2D:
	var sprite2d = Sprite2D.new() 
	sprite2d.texture = texture
	animation_tester.sprite.get_node("Limbs").add_child(sprite2d)
	
	sprite2d.position = pos
	sprite2d.rotation_degrees = rot
	sprite2d.scale = scal
	return sprite2d

func add_sprite_param(daSprite):
	
	history.add_action(history.POSITION, [daSprite, daSprite.position])
	history.add_action(history.ROTATION, [daSprite, daSprite.rotation_degrees])
	history.add_action(history.SCALE, [daSprite, daSprite.scale])
	
	layer_container.create_layer(daSprite)
	
	var draggable_addon = DRAGGABLE_ADDON.instantiate()
	draggable_addon.set_button(daSprite.texture.get_size())
	daSprite.add_child(draggable_addon)
