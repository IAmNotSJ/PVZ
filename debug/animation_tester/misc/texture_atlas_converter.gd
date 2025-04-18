extends Node

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# THIS IS BASED OFF OF THIS PLUGIN FOR GODOT; I JUST KINDA MODIFIED IT TO FIT IN HERE   #
#                              ORIGINALLY MADE BY KAUTARUMA                             #
#                    https://github.com/KAUTARUMA/godot-texture-atlas                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

const NAMES = {
	"ANIMATION": "AN",
	"SYMBOL_DICTIONARY": "SD",
	"TIMELINE": "TL",
	"LAYERS": "L",
	"Frames": "FR",
	"Symbols": "S",
	"name": "N",
	"SYMBOL_name": "SN",
	"elements": "E",
	"Layer_name": "LN",
	"index": "I",
	"duration": "DU",
	"ATLAS_SPRITE_instance": "ASI",
	"Instance_Name": "IN",
	"symbolType": "ST",
	"movieclip": "MC",
	"graphic": "G",
	"firstFrame": "FF",
	"loop": "LP",
	"Matrix3D": "M3D",
	"metadata": "MD",
	"framerate": "FRT"
}



func _ready():
	var anim_json = load("res://debug/animation_tester/misc/texture_atlas_converter/test/happy/Animation.json")
	var spritemap_json = load("res://debug/animation_tester/misc/texture_atlas_converter/test/happy/spritemap1.json")
	#print(anim_json.data)
	#print(spritemap_json.data)
	_load_atlas(anim_json, spritemap_json)

func _load_atlas(anim_json:JSON, spritemap_json:JSON):
	
	var symbols:Dictionary[String, Array] = {}
	var rects:Dictionary[String, Rect2i] = {}
	var frames:Dictionary[String, Dictionary] = {}
	
	var is_optimized:bool = false
	
	var sprites = []
	for sprite in spritemap_json.data["ATLAS"]["SPRITES"]:
		var sprite_info = sprite["SPRITE"]
		rects[sprite_info["name"]] = Rect2i(
			int(sprite_info["x"]), 
			int(sprite_info["y"]), 
			int(sprite_info["w"]), 
			int(sprite_info["h"])
			)
	
	if anim_json.data.has(NAMES["SYMBOL_DICTIONARY"]):
		for symbol_data in anim_json.data[NAMES["SYMBOL_DICTIONARY"]][NAMES["Symbols"]]:
			symbols[symbol_data[NAMES["SYMBOL_name"]]] = symbol_data[NAMES["TIMELINE"]][NAMES["LAYERS"]]
			symbols[symbol_data[NAMES["SYMBOL_name"]]].reverse()
	
	symbols["_top"] = anim_json.data[NAMES["ANIMATION"]][NAMES["TIMELINE"]][NAMES["LAYERS"]]
	symbols["_top"].reverse()
	
	for symbol in symbols.keys():
		for layer in symbols[symbol]:
			for frame in layer[NAMES["Frames"]]:
				frames[symbol][NAMES["Frames"]] 

func m3d_to_transform2d(matrix, is_optimized) -> Transform2D:
	var x_axis:Vector2
	var y_axis:Vector2
	var translation:Vector2
	
	if is_optimized:
		x_axis = Vector2(matrix[0], matrix[1])
		y_axis = Vector2(matrix[4], matrix[5])
		translation = Vector2(matrix[12], matrix[13])
	else:
		x_axis = Vector2(matrix["m00"], matrix["m01"])
		y_axis = Vector2(matrix["m10"], matrix["m11"])
		translation = Vector2(matrix["m30"], matrix["m31"])

	return Transform2D(x_axis, y_axis, translation)
