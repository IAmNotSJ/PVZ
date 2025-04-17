class_name Inspector extends ScrollContainer

const NODE_PROPERTIES = {
	"CanvasItem" : {
		"Visibility": ["visible", "modulate", "self_modulate"],
		"Ordering" : ["z_index"]
	},
	"Node2D" : {
		"Transform" : 	["position", "rotation_degrees", "scale", "skew"]
	},
	"Sprite2D" : {
		"Offset" : ["offset", "flip_h", "flip_v"],
		"Animation" : ["h_frames", "v_frames", "frame"]
	}
}
const CATEGORY_SCENE = preload("res://debug/animation_tester/inspector/categories/category.tscn")

@onready var animation_tester = find_parent("Animation Tester")
@onready var container = $container

func _ready():
	if animation_tester != null:
		animation_tester.selection_changed.connect(_on_selection_changed)
		animation_tester.selection_cleared.connect(clear)

func _on_selection_changed(new_selection):
	print(new_selection)
	clear()
	for daClass in NODE_PROPERTIES.keys():
		for category in NODE_PROPERTIES[daClass].keys():
			var instanced_category = CATEGORY_SCENE.instantiate()
			instanced_category.reference = new_selection.parent
			instanced_category.category_name = category
			container.add_child(instanced_category)
			instanced_category.load_variables(NODE_PROPERTIES[daClass][category])

func clear():
	print('clearing inspector')
	for child in container.get_children():
		child.queue_free()
