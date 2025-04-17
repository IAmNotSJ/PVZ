extends ColorRect

@onready var options = $Options
@onready var animation_tester = find_parent("Animation Tester")

const FILE_OPTIONS:Array = [
	["New Sprite", []],
	["Load Sprite", []]
]
@onready var FILE_FUNCTIONS:Array = [
	[%File, "on_new_sprite_selected"], 
	[%File, "on_load_sprite_pressed"], 
	0
]

const INSERT_OPTIONS:Array = [
	["New Image", []]
]
@onready var INSERT_FUNCTIONS:Array = [
	[%Insert, "on_add_image_pressed"]
]

const SELECTION_OPTIONS:Array = [
	["Deselect", []]
]
@onready var SELECTION_FUNCTIONS:Array = [
	[animation_tester, "deselect"]
]

@onready var TABS:Array = [[%File, FILE_OPTIONS, FILE_FUNCTIONS], [%Insert, INSERT_OPTIONS, INSERT_FUNCTIONS], [%Selection, SELECTION_OPTIONS, SELECTION_FUNCTIONS]]
func _ready():
	for child in $Options.get_children():
		child.toggled.connect(_on_option_toggled)
	for tab in TABS:
		for i in range(tab[1].size()):
			if tab[1][i][1] == []:
				tab[0].get_popup().add_item(tab[1][i][0])
			elif tab[1][i][1] != []:
				var new_popup:PopupMenu = PopupMenu.new()
				for subitem in tab[1][i][1]:
					new_popup.add_item(subitem)
				tab[0].get_popup().add_submenu_node_item(tab[1][i][0], new_popup)
		if tab[2] is Array:
			tab[0].get_popup().index_pressed.connect(_on_popup_item_selected.bind(tab[2]))

func _on_popup_item_selected(id:int, array):
	var callable = Callable(array[id][0], array[id][1])
	print(array[id])
	callable.call()

func _on_option_toggled(toggled_on):
	if toggled_on:
		await get_tree().process_frame
		global.mouse.use_system_mouse()
	else:
		global.mouse.use_custom_mouse()
